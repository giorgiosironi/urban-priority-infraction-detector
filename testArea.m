function test_suite = testArea
initTestSuite;

function testCreatesItselfFromOppositeCorners
area = Area.fromXYtoXY(1, 2, 3, 4);
assertEqual(uint16(1), area.minX);
assertEqual(uint16(2), area.minY);
assertEqual(uint16(3), area.maxX);
assertEqual(uint16(4), area.maxY);

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

function testCutsAnImageOverItsMask
area = Area.fromXYtoXY(1, 2, 3, 4);
image = [0 1 1 1; 0 1 1 1; 0 1 1 1; 0 0 0 0];
cut = area.cut(image);
assertEqual(ones(3), cut);

function testCalculatesCentroid
area = Area.fromXYtoXY(11, 21, 30, 40);
centroid = area.getCentroid();
assertEqual(uint16([21 31]), centroid);

