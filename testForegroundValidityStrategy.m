function test_suite = testForegroundValidityStrategy
initTestSuite;

function testAnImagePortionWithPercentageOfBackgroundAboveTheThresholdIsNotValid
strategy = ForegroundValidityStrategy(40);
validPortion = [-1 40; 50 250];
notValidPortion = [-1 40; -1 250];
assertTrue(strategy.isValid(validPortion));
assertFalse(strategy.isValid(notValidPortion));
