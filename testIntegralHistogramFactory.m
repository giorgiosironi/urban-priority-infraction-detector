function test_suite = testIntegralHistogramFactory
initTestSuite;

function testCalculatesItselfByAddingOnePixelAtTheTimeIfBuiltMonotonically
integralHFactory = IntegralHistogramFactory();
singleHistograms = [1 2 3; 4 6 6; 5 6 7];
integralH = integralHFactory.buildFromImage(singleHistograms);
assertEqual(getSampleCumulativeHistogram(), integralH);

function testWorksAlsoWithObjects
integralHFactory = IntegralHistogramFactory();
singleHistograms = [GrayHistogram([0; 5]) GrayHistogram([10; 0]); GrayHistogram([0; 20]) GrayHistogram([20; 0])];
integralH = integralHFactory.buildFromImage(singleHistograms);
assertEqual(GrayHistogram([0; 5]), integralH.content(1, 1));
assertEqual(GrayHistogram([10; 5]), integralH.content(1, 2));
assertEqual(GrayHistogram([0; 25]), integralH.content(2, 1));
assertEqual(GrayHistogram([30; 25]), integralH.content(2, 2));

function integralH = getSampleCumulativeHistogram
content = [1 3 6; 5 13 22; 10 24 40];
integralH = IntegralHistogram(content);

