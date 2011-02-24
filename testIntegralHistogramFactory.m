function test_suite = testIntegralHistogramFactory
initTestSuite;

function testCalculatesItselfByAddingOnePixelAtTheTimeIfBuiltMonotonically
integralHFactory = IntegralHistogramFactory();
singleHistograms = {1 2 3; 4 6 6; 5 6 7};
integralH = integralHFactory.buildFromImage(singleHistograms);
assertEqual(getSampleCumulativeHistogram(), integralH);

function integralH = getSampleCumulativeHistogram
content = {1 3 6; 5 13 22; 10 24 40};
integralH = IntegralHistogram(content);

