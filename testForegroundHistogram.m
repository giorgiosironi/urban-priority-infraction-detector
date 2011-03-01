function test_suite = testForegroundHistogram
initTestSuite;

function testAssessItsValidity()
valid = ForegroundHistogram(1, 9);
leastValid = ForegroundHistogram(2, 8);
notValid = ForegroundHistogram(3, 7);
assertEqual(1, valid.isValid(20));
assertEqual(1, leastValid.isValid(20));
assertEqual(0, notValid.isValid(20));
