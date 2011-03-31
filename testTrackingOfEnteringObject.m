L = 100;
LTracking = 12;
remover = BackgroundRemover(10, -1);
finder = ObjectFinder(PatchesSelector(24, 32), ForegroundValidityStrategy(50), LabelsContainerFactory());
factory = IntegralHistogramFactory(GrayHistogramStrategy(16));
patchFinder = PatchFinder(30, 30, 4, SimpleComparator());
templateUpdater = HistogramsTemplateUpdater(MaximumDistanceAcceptanceStrategy(SimpleComparator(), 0.1));
expansionUpdater = ExpansionTemplateUpdater(ForegroundValidityStrategy(50));
markers = 'ox+.*sd<>v^ph';
startFrameNumber = 1350;
%startFrameNumber = 832;
repository = ObjectRepository();
rectification_config;
estimator = HomographyEstimator();
rectificationT = estimator.getHomography(from, to);
trajectories = {Trajectory({Area.aroundPoint(231, 13)}); Trajectory({Area.aroundPoint(264, 626)})};

frames = cell(L, 1);
video = zeros(480, 640, 1, L);
for i=1:L
    frameNumber = startFrameNumber + i;
    frame = imread(sprintf('frames/image%d.jpg', frameNumber));
    frames{i} = Frame(rgb2gray(frame));
    video(:, :, 1, i) = frames{i}.content;
end
video = remover.filter(video);
sizeLimits = size(video(:, :, 1, 1));
'Background removed'
for i=1:LTracking
    integralHistograms{i} = factory.buildFromImage(frames{i}.content);
    sprintf('Acquired frame %d with integral histogram', i)
end

objectSightings = finder.findInForeground(Frame(video(:, :, 1, 1)), integralHistograms{1});
sprintf('Objects found: %d', size(objectSightings, 1))
figure;
imshow(frames{1}.content);
plotObjects(objectSightings, markers, 'r');
repository.initializeObjects(objectSightings, 1);

for k=2:LTracking
    sprintf('Looking in %d frame', k)
    for i=1:size(objectSightings, 1)
        if (objectSightings{i}.isOutOfImage())
            continue;
        end
        patches = objectSightings{i}.patches;
        voteMaps = cell(0);
        sprintf('Object %d with %d patches', i, size(patches, 1));
        for j=1:size(patches, 1)
            map = patchFinder.search(patches{j}, integralHistograms{k});
            if (map ~= false)
                voteMaps = [voteMaps; {map}];
            end
        end
        if (size(voteMaps, 1) < 1)
            continue;
        end
        map = VoteMap.combine(voteMaps, VoteMapPercentileStrategy(25));
        [distances, indexes] = sort(map.distances, 'ascend');
        offsets = map.offsets(indexes(1), :);
        dx = offsets(1);
        dy = offsets(2);
        objectSightings{i} = objectSightings{i}.move(dx, dy, sizeLimits);
        objectSightings{i} = templateUpdater.updateTemplate(objectSightings{i}, integralHistograms{k});
    end
    nextFrame = Frame(video(:, :, 1, k));
    nextFrame = nextFrame.removeObjects(objectSightings);
    newlyDetectedObjects = finder.findInForeground(nextFrame, integralHistograms{1});
%    nextFrame = nextFrame.removeObjects(newlyDetectedObjects);
    newObjectSightings = expansionUpdater.updateTemplate(objectSightings, nextFrame, integralHistograms{k}, newlyDetectedObjects);
    figure;
    imshow(frames{k}.content);
    plotObjects(newObjectSightings, markers, 'r');
 %   plotObjects(newlyDetectedObjects, markers, 'b');
    repository.trackObjects(objectSightings, newObjectSightings, k);
    objectSightings = newObjectSightings;
end

objectsByTrajectories = repository.clusterObjects(trajectories);
southObjectsByTrajectories = objectsByTrajectories.filter(SouthAreaFilter());
rectifiedObjectsByTrajectories = southObjectsByTrajectories.filter(RectificationAreaFilter(rectificationT));

