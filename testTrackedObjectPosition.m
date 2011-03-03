function test_suite = testTrackedObjectPosition
initTestSuite;

function testMovesAlongAVector
dummyH = 42;
position = TrackedObjectPosition({Patch(dummyH, Area.fromXYtoXY(1, 11, 10, 20))});
newPosition = position.move(100, 200);
assertEqual([1 1], size(newPosition.patches));
assertEqual(Area.fromXYtoXY(101, 211, 110, 220), newPosition.patches{1}.area);
assertEqual(dummyH, newPosition.patches{1}.histogram);
