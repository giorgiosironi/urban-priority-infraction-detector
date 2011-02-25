function test_suite = testHistogramsCalculator
initTestSuite;

function testBuildsAnIntegralHistogramWithTheGivenStrategy
frame = zeros(10, 2);
frame(9, :) = ones(1, 2)* 120;
frame(10, :) = ones(1, 2) * 250;
histogramCalculator = HistogramsCalculator(GrayHistogramStrategy(4), IntegralHistogramFactory());
integralH = histogramCalculator.createIntegralHistogram(frame);
assertEqual(GrayHistogramStrategy(4), integralH.strategy);
assertEqual([8; 1; 0; 1], squeeze(integralH.content(10, 1, :)));
assertEqual([16; 2; 0; 2], squeeze(integralH.content(10, 2, :)));
