function test_suite = testIntegralHistogram
initTestSuite;

function testCalculatesHistogramOfAnAreaBySubtractionOfIntegralHistograms
integralH = getSampleCumulativeHistogram();
H = integralH.getHistogram(Area.fromXYtoXY(2, 2, 3, 3));
assertEqual(GrayHistogram([25; 25]), H);

function testOverridesSize
integralH = getSampleCumulativeHistogram();
assertEqual([3 3], integralH.size());

function testProvidesHistogramAlsoOfPatchesInTheTopMostAndLeftMostRegion
integralH = getSampleCumulativeHistogram();
H = integralH.getHistogram(Area.fromXYtoXY(1, 1, 2, 2));
assertEqual(GrayHistogram([13; 13]), H);

function integralH = getSampleCumulativeHistogram
content(:, :, 1) = [1 3 6; 5 13 22; 10 24 40];
content(:, :, 2) = [1 3 6; 5 13 22; 10 24 40];
integralH = IntegralHistogram(content, GrayHistogramStrategy(1));

