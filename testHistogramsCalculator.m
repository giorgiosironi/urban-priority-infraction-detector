function test_suite = testHistogramsCalculator
initTestSuite;

function testMakesAPatchVoteForCandidateCentroids_SamePosition
frame = zeros(10, 2);
frame(9, :) = ones(1, 2)* 120;
frame(10, :) = ones(1, 2) * 250;
histogramCalculator = HistogramsCalculator(GrayHistogramStrategy(4), IntegralHistogramFactory());
integralH = histogramCalculator.createIntegralHistogram(frame);
assertEqual(GrayHistogram([8; 1; 0; 1]), integralH.content{10, 1});
assertEqual(GrayHistogram([16; 2; 0; 2]), integralH.content{10, 2});
