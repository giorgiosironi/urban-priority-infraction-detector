function test_suite = testTrackedObjectPosition
initTestSuite;

function testMovesAlongAVector
dummyH = 42;
position = TrackedObjectPosition({Patch(dummyH, Area.fromXYtoXY(1, 11, 10, 20)); Patch(dummyH, Area.fromXYtoXY(11, 11, 20, 20))});
newPosition = position.move(100, 200);
assertEqual([2 1], size(newPosition.patches));
assertEqual(Area.fromXYtoXY(101, 211, 110, 220), newPosition.patches{1}.area);
assertEqual(Area.fromXYtoXY(111, 211, 120, 220), newPosition.patches{2}.area);
assertEqual(dummyH, newPosition.patches{1}.histogram);

function testAddsPatchesToUpdateItsTemplate
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
position = position.addPatches({Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertEqual([2 1], size(position.patches));

function testAddsPatchesThatCoverTheSameAreaOnlyOnce
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
position = position.addPatches({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
assertEqual([1 1], size(position.patches));

function testCollidesWithAnAreaIfOneOfItsAreasCollideWithIt
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(position.collidesWith(Area.fromXYtoXY(2, 3, 3, 4)));
assertFalse(position.collidesWith(Area.fromXYtoXY(3, 3, 4, 4)));

function testCollidesWithAnotherObjectIfOneOfItsAreasCollideWithIt
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(position.collidesWithObject(position));
assertTrue(position.collidesWithObject(TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 2, 3, 4))})));
assertFalse(position.collidesWithObject(TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(10, 10, 12, 12))})));
