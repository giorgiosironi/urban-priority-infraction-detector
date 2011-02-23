function test_suite = testPatchFinder
initTestSuite;

function testMakesAPatchVoteForCandidateCentroids_SamePosition
finder = PatchFinder(3, 3, SimpleComparator());
patch = Patch(GreyHistogram([0; 1]), Area.fromXYtoXY(100, 100, 102, 102));
image = zeros(200, 200);
%image(110:112, 120:122) = ones(3, 3);
image(100:102, 100:102) = ones(3, 3) * 255;
voteMap = finder.search(patch, image);
positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([0 0], voteMap.offsets(positionOfMinimum, :));

function testMakesAPatchVoteForCandidateCentroids_MovedPosition
finder = PatchFinder(5, 5, SimpleComparator());
patch = Patch(GreyHistogram([0; 1]), Area.fromXYtoXY(100, 100, 102, 102));
image = zeros(200, 200);
image(102:104, 103:105) = ones(3, 3) * 255;
voteMap = finder.search(patch, image);
positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([2 3], voteMap.offsets(positionOfMinimum, :));
