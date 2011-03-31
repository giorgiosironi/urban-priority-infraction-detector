function test_suite = testObjectSighting
initTestSuite;

function testMovesAlongAVector
dummyH = 42;
sighting = ObjectSighting({Patch(dummyH, Area.fromXYtoXY(1, 11, 10, 20)); Patch(dummyH, Area.fromXYtoXY(11, 11, 20, 20))});
newSighting = sighting.move(100, 200);
assertEqual(int16([100 200]), newSighting.displacementFromPrevious);
assertEqual([2 1], size(newSighting.patches));
assertEqual(Area.fromXYtoXY(101, 211, 110, 220), newSighting.patches{1}.area);
assertEqual(Area.fromXYtoXY(111, 211, 120, 220), newSighting.patches{2}.area);
assertEqual(dummyH, newSighting.patches{1}.histogram);

function testMovesAndDiscardsPatchesWhichCompletelyExitFromTheImage
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20)); Patch(NaN, Area.fromXYtoXY(11, 11, 20, 20)); Patch(NaN, Area.fromXYtoXY(6, 11, 15, 20))});
newSighting = sighting.move(101, 201, [110 220]);
assertEqual([2 1], size(newSighting.patches));
assertEqual(Area.fromXYtoXY(102, 212, 111, 221), newSighting.patches{1}.area);
assertEqual(Area.fromXYtoXY(107, 212, 116, 221), newSighting.patches{2}.area);

function testConsidersAnObjectWithAllPAtchesRemovedAsHavingGoneOutOfTheImage
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20))});
newSighting = sighting.move(200, 100, [110 220]);
assertFalse(sighting.isOutOfImage());
assertTrue(newSighting.isOutOfImage());

function testAddsPatchesToUpdateItsTemplate
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
sighting = sighting.addPatches({Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertEqual([2 1], size(sighting.patches));

function testAddsPatchesThatCoverTheSameAreaOnlyOnce
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
sighting = sighting.addPatches({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
assertEqual([1 1], size(sighting.patches));

function testCollidesWithAnAreaIfOneOfItsAreasCollideWithIt
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(sighting.collidesWith(Area.fromXYtoXY(2, 3, 3, 4)));
assertFalse(sighting.collidesWith(Area.fromXYtoXY(4, 5, 5, 6)));

function testCollidesWithAnotherObjectIfOneOfItsAreasCollideWithIt
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(sighting.collidesWithObject(sighting));
assertTrue(sighting.collidesWithObject(ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 2, 3, 4))})));
assertFalse(sighting.collidesWithObject(ObjectSighting({Patch(NaN, Area.fromXYtoXY(10, 10, 12, 12))})));

function testCollidesWithAnotherObjectIfIsConnectedToIt
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(11, 21, 20, 30))});
eastSighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(11, 31, 20, 40))});
southSighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(21, 21, 30, 30))});
assertTrue(sighting.collidesWithObject(eastSighting));
assertTrue(sighting.collidesWithObject(southSighting));

function testFilterItsPatchesBasedOnAnAreaFilter
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 10, 10)); Patch(NaN, Area.fromXYtoXY(11, 1, 20, 10))});
filter = SouthAreaFilter();
newSighting = sighting.filter(filter);
assertEqual([1 1], size(newSighting.patches));

function testFiltersAlsoItsDisplacementWhenTransformingTheAreas
sighting = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 10, 10))}, [3 4]);
filter = RectificationAreaFilter(getDilationTForm(2));
newSighting = sighting.filter(filter);
assertEqual(int16([6 8]), newSighting.displacementFromPrevious);

function T = getDilationTForm(factor)
coordinates = [0 0; 1 1; 0 1; 1 0];
T = maketform('projective', coordinates, coordinates * factor);
