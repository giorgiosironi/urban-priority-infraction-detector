selector = PatchesSelector(2, 2);
finder = PatchFinder(20, 20, SimpleComparator(), 16);
frames = cell(2, 1);
frames{1} = Frame.fromFile('frames/image40.jpg');
frames{2} = Frame.fromFile('frames/image41.jpg');

imshow(frames{1}.content);
[y x] = getpts;
objectAreaToTrack = Area.fromXYtoXY(x(1), y(1), x(2), y(2));
areas = selector.getPatchDefinitions(objectAreaToTrack);
patches = cell(0);
voteMaps = cell(0);
for i=1:size(areas, 1)
    cut = areas{i}.cut(rgb2gray(frames{1}.content));
    H = GrayHistogram.fromImageData(cut, 16);
    patch = Patch(H, areas{i});
    patches = [patches; {patch}];
    voteMaps = [voteMaps; {finder.search(patch, rgb2gray(frames{2}.content))}];
    'Finished patch ' + int2str(i)
end
map = VoteMap.sum(voteMaps, 10);
[distances, indexes] = sort(map.distances, 'ascend');
distances(1:5)
map.offsets(indexes(1:5), :)
