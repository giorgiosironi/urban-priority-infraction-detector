L = 100;
remover = BackgroundRemover(10, -1);
finder = ObjectFinder(PatchesSelector(24, 32), ForegroundHistogramStrategy(), 50, LabelsContainerFactory());
factory = IntegralHistogramFactory(GrayHistogramStrategy(16));
patchFinder = PatchFinder(15, 15, SimpleComparator());
matcher = ObjectMatcher(CornersObjectDistanceStrategy());

video = zeros(480, 640, 1, L);
for i=1:L
    frame = imread(sprintf('frames/image%d.jpg', i));
    video(:, :, 1, i) = rgb2gray(frame);
end
video = remover.filter(video);
'Background removed'

frames = cell(2, 1);
%frames{1} = Frame.fromFile('frames/image40.jpg');
im1 = imread('frames/image50.jpg');
frames{1} = Frame(rgb2gray(im1(:, :, :)));
%frames{2} = Frame.fromFile('frames/image41.jpg');
im2 = imread('frames/image51.jpg');
frames{2} = Frame(rgb2gray(im2(:, :, :)));
im2 = imread('frames/image52.jpg');
frames{3} = Frame(rgb2gray(im2(:, :, :)));

firstFrameHistograms = factory.buildFromImage(frames{1}.content);
'Finished integral histogram of 1st frame'
secondFrameHistograms = factory.buildFromImage(frames{2}.content);
'Finished integral histogram of 2nd frame'
thirdFrameHistograms = factory.buildFromImage(frames{3}.content);
'Finished integral histogram of 3rd frame'

objects = finder.findIn(Frame(video(:, :, 1, 50)), firstFrameHistograms);
sprintf('Objects found: %d', size(objects, 1))

for i=1:1%size(objects, 1)
    patches = objects{i}.patches;
    voteMaps = cell(0);
    sprintf('Object %d with %d patches', i, size(patches, 1))
    for j=1:size(patches, 1)
        voteMaps = [voteMaps; {patchFinder.search(patches{j}, secondFrameHistograms)}];
    end
    map = VoteMap.combine(voteMaps, VoteMapPercentileStrategy(25));
    [distances, indexes] = sort(map.distances, 'ascend');
    offsets = map.offsets(indexes(1), :)
    dx = offsets(1);
    dy = offsets(2);
    objects{i} = objects{i}.move(dx, dy);
end

'Looking now in 2nd frame'
for i=1:1%size(objects, 1)
    patches = objects{i}.patches;
    voteMaps = cell(0);
    sprintf('Object %d with %d patches', i, size(patches, 1))
    for j=1:size(patches, 1)
        voteMaps = [voteMaps; {patchFinder.search(patches{j}, thirdFrameHistograms)}];
    end
    size(voteMaps)
    map = VoteMap.combine(voteMaps, VoteMapPercentileStrategy(25));
    [distances, indexes] = sort(map.distances, 'ascend');
    offsets = map.offsets(indexes(1), :)
    dx = offsets(1);
    dy = offsets(2);
    objects{i} = objects{i}.move(dx, dy);
end

