function test_suite = testIntegralHistogramFactory
initTestSuite;

function testWorksWithObjectsToBuildTheHistogramMonotonically
integralHFactory = IntegralHistogramFactory();
singleHistograms = [GrayHistogram([0; 5]) GrayHistogram([10; 0]); GrayHistogram([0; 20]) GrayHistogram([20; 0])];
integralH = integralHFactory.buildFromImage(singleHistograms, GrayHistogramStrategy(2));
assertEqual(GrayHistogramStrategy(2), integralH.strategy);
assertEqual([0; 5], squeeze(integralH.content(1, 1, :)));
assertEqual([10; 5], squeeze(integralH.content(1, 2, :)));
assertEqual([0; 25], squeeze(integralH.content(2, 1, :)));
assertEqual([30; 25], squeeze(integralH.content(2, 2, :)));

function integralH = getSampleCumulativeHistogram
content = [1 3 6; 5 13 22; 10 24 40];
integralH = IntegralHistogram(content);

