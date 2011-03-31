function test_suite = testObjectSighting.newSighting
initTestSuite;

function testMovesAlongAVector
dummyH = 42;
sighting = ObjectSighting.newSighting({Patch(dummyH, Area.fromXYtoXY(1, 11, 10, 20)); Patch(dummyH, Area.fromXYtoXY(11, 11, 20, 20))});
newSighting = sighting.move(100, 200);
assertEqual(int16([100 200]), newSighting.displacementFromPrevious);
assertEqual([2 1], size(newSighting.patches));
assertEqual(Area.fromXYtoXY(101, 211, 110, 220), newSighting.patches{1}.area);
assertEqual(Area.fromXYtoXY(111, 211, 120, 220), newSighting.patches{2}.area);
assertEqual(dummyH, newSighting.patches{1}.histogram);

function testMovesAndDiscardsPatchesWhichCompletelyExitFromTheImage
sighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20)); Patch(NaN, Area.fromXYtoXY(11, 11, 20, 20)); Patch(NaN, Area.fromXYtoXY(6, 11, 15, 20))});
newSighting = sighting.move(101, 201, [110 220]);
assertEqual([2 1], size(newSighting.patches));
assertEqual(Area.fromXYtoXY(102, 212, 111, 221), newSighting.patches{1}.area);
assertEqual(Area.fromXYtoXY(107, 212, 116, 221), newSighting.patches{2}.area);

function testConsidersAnObjectWithAllPAtchesRemovedAsHavingGoneOutOfTheImage
sighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20))});
newSighting = sighting.move(200, 100, [110 220]);
assertFalse(sighting.isOutOfImage());
assertTrue(newSighting.isOutOfImage());

function testAddsPatchesToUpdateItsTemplate
sighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
sighting = sighting.addPatches({Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertEqual([2 1], size(sighting.patches));

function testAddsPatchesThatCoverTheSameAreaOnlyOnce
sighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
sighting = sighting.addPatches({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
assertEqual([1 1], size(sighting.patches));

function testCollidesWithAnAreaIfOneOfItsAreasCollideWithIt
sighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(sighting.collidesWith(Area.fromXYtoXY(2, 3, 3, 4)));
assertFalse(sighting.collidesWith(Area.fromXYtoXY(4, 5, 5, 6)));

function testCollidesWithAnotherObjectIfOneOfItsAreasCollideWithIt
sighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(sighting.collidesWithObject(sighting));
assertTrue(sighting.collidesWithObject(ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(1, 2, 3, 4))})));
assertFalse(sighting.collidesWithObject(ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(10, 10, 12, 12))})));

function testCollidesWithAnotherObjectIfIsConnectedToIt
sighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(11, 21, 20, 30))});
eastSighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(11, 31, 20, 40))});
southSighting = ObjectSighting.newSighting({Patch(NaN, Area.fromXYtoXY(21, 21, 30, 30))});
assertTrue(sighting.collidesWithObject(eastSighting));
assertTrue(sighting.collidesWithObject(southSighting));
