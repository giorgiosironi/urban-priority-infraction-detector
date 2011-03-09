function test_suite = testPatchFinder
initTestSuite;

function testMakesAPatchVoteForCandidateCentroids_SamePosition
finder = PatchFinder(3, 3, 1, SimpleComparator());
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

patch = Patch(GrayHistogram([0; 1]), Area.fromXYtoXY(10, 10, 12, 12));
nextFrame = zeros(20, 20);
nextFrame(10:12, 10:12) = ones(3, 3) * 255;
histograms = histogramFactory.buildFromImage(nextFrame);

voteMap = finder.search(patch, histograms);

positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([0 0], voteMap.offsets(positionOfMinimum, :));

function testMakesAPatchVoteForCandidateCentroids_MovedPosition
finder = PatchFinder(5, 5, 1, SimpleComparator());
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

patch = Patch(GrayHistogram([0; 1]), Area.fromXYtoXY(10, 10, 12, 12));
nextFrame = zeros(20, 20);
nextFrame(12:14, 13:15) = ones(3, 3) * 255;
histograms = histogramFactory.buildFromImage(nextFrame);

voteMap = finder.search(patch, histograms);

positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([2 3], voteMap.offsets(positionOfMinimum, :));

function testIgnoresPatchesWhichAtLeastOneDisplacementWouldPutOutOfTheImage
finder = PatchFinder(3, 3, 1, SimpleComparator());
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

patch = Patch(NaN, Area.fromXYtoXY(18, 18, 19, 19));
nextFrame = zeros(20, 20);
histograms = histogramFactory.buildFromImage(nextFrame);
assertEqual(false, finder.search(patch, histograms));

patch = Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2));
nextFrame = zeros(20, 20);
histograms = histogramFactory.buildFromImage(nextFrame);
assertEqual(false, finder.search(patch, histograms));

function testMovesAPatchForSearchOnlyByAGreaterThanSinglePixelStep
finder = PatchFinder(4, 4, 2, SimpleComparator());
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

patch = Patch(GrayHistogram([0; 1]), Area.fromXYtoXY(10, 10, 12, 12));
nextFrame = zeros(20, 20);
nextFrame(12:14, 12:14) = ones(3, 3) * 255;
% column that should be skipped
nextFrame(12:14, 11) = ones(3, 1) * 255;
histograms = histogramFactory.buildFromImage(nextFrame);

voteMap = finder.search(patch, histograms);

positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([2 2], voteMap.offsets(positionOfMinimum, :));

function testRoundTheMaximumAndMinimumPositionsByMovingByStepFromTheCurrentOne
finder = PatchFinder(5, 5, 2, SimpleComparator());
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

patch = Patch(GrayHistogram([0; 1]), Area.fromXYtoXY(10, 10, 12, 12));
nextFrame = zeros(20, 20);
nextFrame(12:14, 12:14) = ones(3, 3) * 255;
% column that should be skipped
nextFrame(12:14, 11) = ones(3, 1) * 255;
histograms = histogramFactory.buildFromImage(nextFrame);

voteMap = finder.search(patch, histograms);

positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([2 2], voteMap.offsets(positionOfMinimum, :));

