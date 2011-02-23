function test_suite = testGreyHistogram
initTestSuite;

function testCreatesItselfFromImageData
H = GreyHistogram.fromImageData([0 0 0; 120 120 120; 250 250 250], 2);
expectedH = GreyHistogram([6; 3]);
assertEqual(expectedH, H);

function testImplementsAdditionAndSubtraction()
firstH = GreyHistogram([1; 2]);
secondH = GreyHistogram([3; 4]);
assertEqual(GreyHistogram([4; 6]), firstH + secondH);
assertEqual(GreyHistogram([2; 2]), secondH - firstH);
