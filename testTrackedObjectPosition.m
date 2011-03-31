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

function testMovesAndDiscardsPatchesWhichCompletelyExitFromTheImage
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20)); Patch(NaN, Area.fromXYtoXY(11, 11, 20, 20)); Patch(NaN, Area.fromXYtoXY(6, 11, 15, 20))});
newPosition = position.move(101, 201, [110 220]);
assertEqual([2 1], size(newPosition.patches));
assertEqual(Area.fromXYtoXY(102, 212, 111, 221), newPosition.patches{1}.area);
assertEqual(Area.fromXYtoXY(107, 212, 116, 221), newPosition.patches{2}.area);

function testConsidersAnObjectWithAllPAtchesRemovedAsHavingGoneOutOfTheImage
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20))});
newPosition = position.move(200, 100, [110 220]);
assertFalse(position.isOutOfImage());
assertTrue(newPosition.isOutOfImage());

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
assertFalse(position.collidesWith(Area.fromXYtoXY(4, 5, 5, 6)));

function testCollidesWithAnotherObjectIfOneOfItsAreasCollideWithIt
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(position.collidesWithObject(position));
assertTrue(position.collidesWithObject(TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 2, 3, 4))})));
assertFalse(position.collidesWithObject(TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(10, 10, 12, 12))})));

function testCollidesWithAnotherObjectIfIsConnectedToIt
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(11, 21, 20, 30))});
eastPosition = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(11, 31, 20, 40))});
southPosition = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(21, 21, 30, 30))});
assertTrue(position.collidesWithObject(eastPosition));
assertTrue(position.collidesWithObject(southPosition));

function testFilterItsPatchesBasedOnAnAreaFilter
position = TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(1, 1, 10, 10)); Patch(NaN, Area.fromXYtoXY(11, 1, 20, 10))});
filter = SouthAreaFilter();
newPosition = position.filter(filter);
assertEqual([1 1], size(newPosition.patches));
