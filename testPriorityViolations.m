for segmentOffset=0:0
    L = 100;
    LTracking = 50;
    remover = BackgroundRemover(10, -1);
    finder = ObjectFinder(PatchesSelector(24, 32), ForegroundValidityStrategy(50), LabelsContainerFactory());
    factory = IntegralHistogramFactory(GrayHistogramStrategy(16));
    patchFinder = PatchFinder(30, 30, 2, SimpleComparator());
    templateUpdater = HistogramsTemplateUpdater(MaximumDistanceAcceptanceStrategy(SimpleComparator(), 0.1));
    expansionUpdater = ExpansionTemplateUpdater(ForegroundValidityStrategy(50));
    markers = 'ox+.*sd<>v^ph';
    %startFrameNumber = 1350;
    %startFrameNumber = 1365;
    %startFrameNumber = 1320;
    %startFrameNumber = 832;
    startFrameNumber = 46+segmentOffset*LTracking;
    repository = ObjectRepository();
    rectification_config;
    estimator = HomographyEstimator();
    rectificationT = estimator.getHomography(from, to);
    acrossIntersection = Trajectory({Area.aroundPoint(231, 13); Area.aroundPoint(200, 600); Area.aroundPoint(205, 500)});
    mainRoadTurningRight = Trajectory({Area.aroundPoint(264, 626); Area.aroundPoint(205, 500); Area.aroundPoint(200, 600)});
    mainRoadGoingStraight = Trajectory({Area.aroundPoint(180, 103); Area.aroundPoint(269, 450); Area.aroundPoint(253, 335); Area.aroundPoint(308, 582)});
    mainRoadTurningLeft = Trajectory({Area.aroundPoint(198, 131); Area.aroundPoint(207, 300); Area.aroundPoint(205, 500); Area.aroundPoint(205, 596)});
    trajectories = {acrossIntersection; mainRoadTurningRight; mainRoadGoingStraight; mainRoadTurningLeft};

    frames = cell(L, 1);
    video = zeros(480, 640, 1, L);
    for i=1:L
        frameNumber = startFrameNumber + i;
        frame = imread(sprintf('frames/image%d.jpg', frameNumber));
        frames{i} = Frame(rgb2gray(frame));
        video(:, :, 1, i) = frames{i}.content;
    end
    background = median(video, 4);
    rectifiedBackground = imtransform(background, rectificationT, 'XData', [-1000 1000], 'YData', [-1000 1500]);
    video = remover.filter(video);
    sizeLimits = size(video(:, :, 1, 1));
    'Background removed'
    for i=1:LTracking
        integralHistograms{i} = factory.buildFromImage(frames{i}.content);
        sprintf('Acquired frame %d with integral histogram', i);
    end

    objectSightings = finder.findInForeground(Frame(video(:, :, 1, 1)), integralHistograms{1});
    sprintf('Objects found: %d', size(objectSightings, 1));
    %figure;
    %imshow(frames{1}.content);
    %plotObjects(objectSightings, markers, 'r');
    repository.initializeObjects(objectSightings, 1);

    for k=2:LTracking
        sprintf('Looking in %d frame', k);
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
        %figure;
        %imshow(frames{k}.content);
        %plotObjects(newObjectSightings, markers, 'r');
     %   plotObjects(newlyDetectedObjects, markers, 'b');
        repository.trackObjects(objectSightings, newObjectSightings, k);
        objectSightings = newObjectSightings;
    end

    objectsByTrajectories = repository.clusterObjects(trajectories);
    southObjectsByTrajectories = objectsByTrajectories.filter(SouthAreaFilter());
    rectifiedObjectsByTrajectories = southObjectsByTrajectories.filter(RectificationAreaFilter(rectificationT));
    rectifiedModelledObjectsByTrajectories = rectifiedObjectsByTrajectories.modelMovement(LineMovement(3));
    %width is not visible, but should be restored: objectsWithWidth = rectifiedModelledObjectsByTrajectories.filter(StandardWidthAreaFilter(2000));
    priorityRules = PriorityRules(MaxSpeedPositionFilter());
    priorityRules.addPriority(2, 3);
    collidedObjects = rectifiedModelledObjectsByTrajectories.detectCollisions(priorityRules);
    segmentOffset
    rectifiedModelledObjectsByTrajectories.clusters
end

