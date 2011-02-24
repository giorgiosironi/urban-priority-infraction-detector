function test_suite = testIntegralHistogram
initTestSuite;

function testCalculatesHistogramOfAnAreaBySubtractionOfIntegralHistograms
integralH = getSampleCumulativeHistogram();
H = integralH.getHistogram(Area.fromXYtoXY(2, 2, 3, 3));
assertEqual(25, H);

function integralH = getSampleCumulativeHistogram
content = [1 3 6; 5 13 22; 10 24 40];
integralH = IntegralHistogram(content);

