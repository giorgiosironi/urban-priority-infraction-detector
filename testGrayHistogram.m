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
