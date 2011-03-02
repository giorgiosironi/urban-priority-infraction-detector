function test_suite = testCornersObjectDistanceStrategy
initTestSuite;

function testConsiderSimilarGroupOfAreasWhoseExtremasAreNear
strategy = CornersObjectDistanceStrategy();
topLeft = {Area.fromXYtoXY(1, 1, 10, 10) Area.fromXYtoXY(11, 11, 20, 20)};
bottomRight = {Area.fromXYtoXY(101, 101, 110, 110) Area.fromXYtoXY(111, 111, 120, 120)};
topLeftNextFrame = {Area.fromXYtoXY(11, 11, 20, 20) Area.fromXYtoXY(21, 21, 30, 30)};
bottomRightNextFrame = {Area.fromXYtoXY(91, 91, 100, 100) Area.fromXYtoXY(101, 101, 110, 110)};
assertTrue(strategy.computeDistance(topLeft, bottomRightNextFrame) > strategy.computeDistance(topLeft, topLeftNextFrame));
assertTrue(strategy.computeDistance(bottomRight, topLeftNextFrame) > strategy.computeDistance(bottomRight, bottomRightNextFrame));
