function test_suite = testGrayHistogram
initTestSuite;

function testCreatesItselfFromImageData
H = GrayHistogram.fromImageData([0 0 0; 120 120 120; 250 250 250], 2);
expectedH = GrayHistogram([6; 3]);
assertEqual(expectedH, H);

function testImplementsAdditionAndSubtraction()
firstH = GrayHistogram([1; 2]);
secondH = GrayHistogram([3; 4]);
assertEqual(GrayHistogram([4; 6]), firstH + secondH);
assertEqual(GrayHistogram([2; 2]), secondH - firstH);

function testConvertsIntegralValuesInOrderToScaleThemOn255
H = GrayHistogram.fromImageData(uint8([0 0 0; 120 120 120; 250 250 250]), 4);
expectedH = GrayHistogram([3; 3; 0; 3]);
assertEqual(expectedH, H);

