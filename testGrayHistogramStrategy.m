function test_suite = testGrayHistogramStrategy
initTestSuite;

function testAssignABinToTheGrayPixel
strategy = GrayHistogramStrategy(4);
assertEqual(1, strategy.assignBin(0));
assertEqual(1, strategy.assignBin(10));
assertEqual(2, strategy.assignBin(100));
assertEqual(3, strategy.assignBin(170));
assertEqual(4, strategy.assignBin(250));
assertEqual(4, strategy.assignBin(255));

function testWorksAlsoWithMatrixes()
strategy = GrayHistogramStrategy(4);
assertEqual([1 4], strategy.assignBin([0 255]));

function testCreatesAGrayHistogram
strategy = GrayHistogramStrategy(4);
H = strategy.fromBinsData([1; 0; 4; 5]);
assertEqual([1; 0; 4; 5], H.bins);
