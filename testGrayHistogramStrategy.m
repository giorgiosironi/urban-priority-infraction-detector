function test_suite = testGrayHistogramStrategy
initTestSuite;

function testCreatesAGrayHistogram
strategy = GrayHistogramStrategy(2);
H = strategy.fromPixelData(250);
assertEqual(GrayHistogram([0; 1]), H);
H = strategy.fromPixelData(50);
assertEqual(GrayHistogram([1; 0]), H);
