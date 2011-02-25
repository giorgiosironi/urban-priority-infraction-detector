selector = PatchesSelector(2, 2);
finder = PatchFinder(15, 15, SimpleComparator());
frames = cell(2, 1);
%frames{1} = Frame.fromFile('frames/image40.jpg');
im1 = imread('frames/image40.jpg');
frames{1} = Frame(rgb2gray(im1(1:260, 100:250, :)));
%frames{2} = Frame.fromFile('frames/image41.jpg');
im2 = imread('frames/image41.jpg');
frames{2} = Frame(rgb2gray(im2(1:260, 100:250, :)));

imshow(frames{1}.content);
[y x] = getpts;
objectAreaToTrack = Area.fromXYtoXY(x(1), y(1), x(2), y(2));
areas = selector.getPatchDefinitions(objectAreaToTrack);
patches = cell(0);
voteMaps = cell(0);
calculator = HistogramsCalculator(GrayHistogramStrategy(16), IntegralHistogramFactory());
histograms = calculator.createIntegralHistogram(frames{2}.content);
'Finished integral histogram of 2th frame'
for i=1:size(areas, 1)
    cut = areas{i}.cut(frames{1}.content);
    H = GrayHistogram.fromImageData(cut, 16);
    patch = Patch(H, areas{i});
    patches = [patches; {patch}];
    sprintf('Extracted patch %d', i)
    voteMaps = [voteMaps; {finder.search(patch, histograms)}];
    sprintf('Finished patch %d', i)
end
map = VoteMap.sum(voteMaps, 10);
[distances, indexes] = sort(map.distances, 'ascend');
distances(1:5)
map.offsets(indexes(1:5), :)
