function test_suite = testIntegralHistogram
initTestSuite;

function testCalculatesHistogramOfAnAreaBySubtractionOfIntegralHistograms
integralH = IntegralHistogram(3, 3);
integralH.setSingleHistogram(1, 1, 1);
integralH.setSingleHistogram(2, 1, 5);
integralH.setSingleHistogram(3, 1, 10);
integralH.setSingleHistogram(1, 2, 3);
integralH.setSingleHistogram(2, 2, 13);
integralH.setSingleHistogram(3, 2, 24);
integralH.setSingleHistogram(1, 3, 6);
integralH.setSingleHistogram(2, 3, 22);
integralH.setSingleHistogram(3, 3, 40);
H = integralH.getHistogram(Area.fromXYtoXY(2, 2, 3, 3));
assertEqual(25, H);

