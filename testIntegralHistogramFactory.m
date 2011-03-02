function test_suite = testIntegralHistogramFactory
initTestSuite;

function testWorksWithObjectsToBuildTheHistogramMonotonically
integralHFactory = IntegralHistogramFactory(GrayHistogramStrategy(4));
image = [0 0 100; 150 150 200; 250 250 255];
integralH = integralHFactory.buildFromImage(image);
assertEqual(GrayHistogramStrategy(4), integralH.strategy);
assertEqual([1; 0; 0; 0], squeeze(integralH.content(1, 1, :)));
assertEqual([1; 0; 1; 1], squeeze(integralH.content(3, 1, :)));
assertEqual([2; 1; 0; 0], squeeze(integralH.content(1, 3, :)));
assertEqual([2; 1; 2; 4], squeeze(integralH.content(3, 3, :)));
