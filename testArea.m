function test_suite = testArea
initTestSuite;

function testCreatesItselfFromOppositeCorners
area = Area.fromXYtoXY(1, 2, 3, 4);
assertTrue(1 == area.minX);
assertTrue(2 == area.minY);
assertTrue(3 == area.maxX);
assertTrue(4 == area.maxY);

function testCreatesADisplacedVersionOfItself
area = Area.fromXYtoXY(1, 2, 3, 4);
displacedArea = area.displace(100, 200);
expectedArea = Area.fromXYtoXY(101, 202, 103, 204);
assertEqual(expectedArea, displacedArea);

function testCreatesTheFourConnectedDisplacedVersionOfItself
area = Area.fromXYtoXY(101, 3, 102, 4);
neighbors = area.getNeighbors();
assertEqual(Area.fromXYtoXY(101, 1, 102, 2), neighbors{1});
assertEqual(Area.fromXYtoXY(103, 3, 104, 4), neighbors{2});
assertEqual(Area.fromXYtoXY(101, 5, 102, 6), neighbors{3});
assertEqual(Area.fromXYtoXY(99, 3, 100, 4), neighbors{4});

function testLimitsItsFourConnectedDisplacementOnTheWestAndNorthSidesOfTheImage
area = Area.fromXYtoXY(1, 1, 2, 2);
neighbors = area.getNeighbors();
assertEqual([2 1], size(neighbors));
assertEqual(Area.fromXYtoXY(3, 1, 4, 2), neighbors{1});
assertEqual(Area.fromXYtoXY(1, 3, 2, 4), neighbors{2});

function testLimitsItsFourConnectedDisplacementOnTheSouthAndEastSidesOfTheImage
area = Area.fromXYtoXY(1, 1, 2, 2);
neighbors = area.getNeighbors([2, 2]);
assertEqual([0], size(neighbors, 1));

function testLimitsTheFourConnectedDisplacementOfAnAreaToValidOverallAreasWhichAreStrictlyContainedInTheFrame
area = Area.fromXYtoXY(2, 1, 3, 2);
neighbors = area.getNeighbors([2, 10]);
assertEqual([0], size(neighbors, 1));

function testCutsAnImageOverItsMask
area = Area.fromXYtoXY(1, 2, 3, 4);
image = [0 1 1 1; 0 1 1 1; 0 1 1 1; 0 0 0 0];
cut = area.cut(image);
assertEqual(ones(3), cut);

function testCalculatesCentroid
area = Area.fromXYtoXY(11, 21, 30, 40);
centroid = area.getCentroid();
assertTrue(21 == centroid(1));
assertTrue(31 == centroid(2));

function testDetectsCollisionWithAnotherArea
area = Area.fromXYtoXY(11, 31, 20, 40);
assertTrue(area.collidesWith(Area.fromXYtoXY(19, 39, 100, 100)));
assertFalse(area.collidesWith(Area.fromXYtoXY(22, 42, 100, 100)));
assertFalse(area.collidesWith(Area.fromXYtoXY(22, 39, 100, 100)));
assertFalse(area.collidesWith(Area.fromXYtoXY(19, 42, 100, 100)));
assertTrue(area.collidesWith(Area.fromXYtoXY(1, 1, 12, 32)));
assertFalse(area.collidesWith(Area.fromXYtoXY(1, 1, 9, 32)));
assertFalse(area.collidesWith(Area.fromXYtoXY(1, 1, 12, 29)));
intersectingArea = Area.fromXYtoXY(18, 35, 26, 37);
assertTrue(area.collidesWith(intersectingArea));
assertTrue(intersectingArea.collidesWith(area));

function testCollidesWithAdjacentAreas
area = Area.fromXYtoXY(11, 31, 20, 40);
assertTrue(area.collidesWith(Area.fromXYtoXY(11, 41, 20, 50)));
assertTrue(area.collidesWith(Area.fromXYtoXY(21, 31, 30, 40)));

function testCollidesWithIdenticalArea
area = Area.fromXYtoXY(11, 31, 20, 40);
assertTrue(area.collidesWith(area));

function testDetectsContainmentOfAnotherArea
area = Area.fromXYtoXY(1, 5, 4, 10);
assertTrue(area.contains(Area.fromXYtoXY(2, 5, 4, 9)));
assertFalse(area.contains(Area.fromXYtoXY(1, 4, 4, 10)));
assertFalse(area.contains(Area.fromXYtoXY(1, 5, 4, 12)));

function testLimitsItselfToAPredefinedMaximumArea
area = Area.fromXYtoXY(-1, 1, 20, 10000);
assertEqual(Area.fromXYtoXY(1, 1, 20, 640), area.limit(Area.fromDimensions(480, 640)));
