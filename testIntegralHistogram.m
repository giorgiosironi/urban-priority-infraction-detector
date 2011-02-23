function test_suite = testIntegralHistogram
initTestSuite;

function testCalculatesHistogramOfAnAreaBySubtractionOfIntegralHistograms
integralH = getSampleCumulativeHistogram();
H = integralH.getHistogram(Area.fromXYtoXY(2, 2, 3, 3));
assertEqual(25, H);

function testCalculatesItselfByAddingOnePixelAtTheTimeIfBuiltMonotonically
integralH = IntegralHistogram(3, 3);
integralH.setPixel(1, 1, 1);
integralH.setPixel(2, 1, 4);
integralH.setPixel(3, 1, 5);
integralH.setPixel(1, 2, 2);
integralH.setPixel(2, 2, 6);
integralH.setPixel(3, 2, 6);
integralH.setPixel(1, 3, 3);
integralH.setPixel(2, 3, 6);
integralH.setPixel(3, 3, 7);
assertEqual(getSampleCumulativeHistogram(), integralH);

function integralH = getSampleCumulativeHistogram
integralH = IntegralHistogram(3, 3);
integralH.setCumulativeHistogramAt(1, 1, 1);
integralH.setCumulativeHistogramAt(2, 1, 5);
integralH.setCumulativeHistogramAt(3, 1, 10);
integralH.setCumulativeHistogramAt(1, 2, 3);
integralH.setCumulativeHistogramAt(2, 2, 13);
integralH.setCumulativeHistogramAt(3, 2, 24);
integralH.setCumulativeHistogramAt(1, 3, 6);
integralH.setCumulativeHistogramAt(2, 3, 22);
integralH.setCumulativeHistogramAt(3, 3, 40);

