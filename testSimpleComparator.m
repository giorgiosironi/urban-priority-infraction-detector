function test_suite = testSimpleComparator
initTestSuite;

function testComparesHistogramViaVectorDistance
comparator = SimpleComparator();
firstHBins = [1; 0];
secondHBins = [0; 1];
assertElementsAlmostEqual(sqrt(2), comparator.getDistance(firstHBins, secondHBins));

function testComparesNormalizedVersionOfHistograms
comparator = SimpleComparator();
firstHBins = [3; 0];
secondHBins = [0; 4];
assertElementsAlmostEqual(sqrt(2), comparator.getDistance(firstHBins, secondHBins));
