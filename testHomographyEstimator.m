function test_suite = testHomographyEstimator
initTestSuite;

function testProducesAnHomographyMatrixForDilations
from = [0 0; 10 0; 10 10; 0 10];
to = [0 0; 200 0; 200 100; 0 100];

estimator = HomographyEstimator();
T = estimator.getHomography(from, to);
[y, x] = tformfwd(T, 3, 1);
assertElementsAlmostEqual(20, x);
assertElementsAlmostEqual(30, y);

function testProducesAnHomographyMatrixForRotations
from = [0 0; 100 0; 100 100; 0 100];
to = [100 0; 100 100; 0 100; 0 0];

estimator = HomographyEstimator();
T = estimator.getHomography(from, to);
[y, x] = tformfwd(T, 50, 50);
assertElementsAlmostEqual(50, x);
assertElementsAlmostEqual(50, y);


