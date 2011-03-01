L = 100;
remover = BackgroundRemover(10, -1);
finder = ObjectFinder(PatchesSelector(48, 64), ForegroundHistogramStrategy(), 10, LabelsContainerFactory());

video = zeros(480, 640, 1, L);
for i=1:L
    frame = imread(sprintf('frames/image%d.jpg', i));
    video(:, :, 1, i) = rgb2gray(frame);
end
video = remover.filter(video);
'Background removed'

objects = finder.findIn(Frame(video(:, :, 1, 40)));
sprintf('Objects found: %d', size(objects, 1))

frames = cell(2, 1);
%frames{1} = Frame.fromFile('frames/image40.jpg');
im1 = imread('frames/image40.jpg');
frames{1} = Frame(rgb2gray(im1(:, 1:300, :)));
%frames{2} = Frame.fromFile('frames/image41.jpg');
im2 = imread('frames/image41.jpg');
frames{2} = Frame(rgb2gray(im2(:, 1:300, :)));
calculator = HistogramsCalculator(GrayHistogramStrategy(16), IntegralHistogramFactory());
histograms = calculator.createIntegralHistogram(frames{2}.content);
'Finished integral histogram of 2th frame'
finder = PatchFinder(15, 15, SimpleComparator());

imshow(frames{1}.content);
for i=1:size(objects, 1)
    areas = objects{i}.areas;
    patches = cell(0);
    voteMaps = cell(0);
    for j=1:size(areas, 1)
        cut = areas{j}.cut(frames{1}.content);
        H = GrayHistogram.fromImageData(cut, 16);
        patch = Patch(H, areas{j});
        patches = [patches; {patch}];
        voteMaps = [voteMaps; {finder.search(patch, histograms)}];
    end
    map = VoteMap.combine(voteMaps, VoteMapPercentileStrategy(75));
    [distances, indexes] = sort(map.distances, 'ascend');
    sprintf('Object %d with %d patches', i, size(areas, 1))
    distances(1:5)
    map.offsets(indexes(1:5), :)
end
