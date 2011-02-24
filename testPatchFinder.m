function test_suite = testPatchFinder
initTestSuite;

function testMakesAPatchVoteForCandidateCentroids_SamePosition
finder = PatchFinder(3, 3, SimpleComparator());
histogramCalculator = HistogramsCalculator(GrayHistogramStrategy(2), IntegralHistogramFactory());

patch = Patch(GrayHistogram([0; 1]), Area.fromXYtoXY(10, 10, 12, 12));
nextFrame = zeros(20, 20);
nextFrame(10:12, 10:12) = ones(3, 3) * 255;
histograms = histogramCalculator.createIntegralHistogram(nextFrame);

voteMap = finder.search(patch, histograms);

positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([0 0], voteMap.offsets(positionOfMinimum, :));

function testMakesAPatchVoteForCandidateCentroids_MovedPosition
finder = PatchFinder(5, 5, SimpleComparator());
histogramCalculator = HistogramsCalculator(GrayHistogramStrategy(2), IntegralHistogramFactory());

patch = Patch(GrayHistogram([0; 1]), Area.fromXYtoXY(10, 10, 12, 12));
nextFrame = zeros(20, 20);
nextFrame(12:14, 13:15) = ones(3, 3) * 255;
histograms = histogramCalculator.createIntegralHistogram(nextFrame);

voteMap = finder.search(patch, histograms);

positionOfMinimum = find(voteMap.distances == 0);
assertEqual([1 1], size(positionOfMinimum));
assertTrue(positionOfMinimum > 0);
assertEqual([2 3], voteMap.offsets(positionOfMinimum, :));
