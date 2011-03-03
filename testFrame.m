function test_suite = testFrame
initTestSuite;

function testCreatesItselfFromMatrix
frame = Frame(ones(2, 3));
assertEqual(ones(2,3), frame.content);

function testCreatesItselfFromImageFile
frame = Frame.fromFile('frames/image40.jpg');
assertEqual([480 640 3], size(frame.content));
area = frame.getArea();
assertTrue(1 == area.minX);
assertTrue(1 == area.minY);
assertTrue(480 == area.maxX);
assertTrue(640 == area.maxY);

function testCanBeCutWithAnArea()
content = zeros(10, 10);
content(5, 6) = 1;
frame = Frame(content);
result = frame.cut(Area.fromXYtoXY(5, 6, 5, 6));
assertEqual(1, result);
