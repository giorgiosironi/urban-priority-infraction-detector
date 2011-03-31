function test_suite = testObjectSighting
initTestSuite;

function testMovesAlongAVector
dummyH = 42;
position = ObjectSighting({Patch(dummyH, Area.fromXYtoXY(1, 11, 10, 20)); Patch(dummyH, Area.fromXYtoXY(11, 11, 20, 20))});
newPosition = position.move(100, 200);
assertEqual(int16([100 200]), newPosition.displacementFromPrevious);
assertEqual([2 1], size(newPosition.patches));
assertEqual(Area.fromXYtoXY(101, 211, 110, 220), newPosition.patches{1}.area);
assertEqual(Area.fromXYtoXY(111, 211, 120, 220), newPosition.patches{2}.area);
assertEqual(dummyH, newPosition.patches{1}.histogram);

function testMovesAndDiscardsPatchesWhichCompletelyExitFromTheImage
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20)); Patch(NaN, Area.fromXYtoXY(11, 11, 20, 20)); Patch(NaN, Area.fromXYtoXY(6, 11, 15, 20))});
newPosition = position.move(101, 201, [110 220]);
assertEqual([2 1], size(newPosition.patches));
assertEqual(Area.fromXYtoXY(102, 212, 111, 221), newPosition.patches{1}.area);
assertEqual(Area.fromXYtoXY(107, 212, 116, 221), newPosition.patches{2}.area);

function testConsidersAnObjectWithAllPAtchesRemovedAsHavingGoneOutOfTheImage
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 11, 10, 20))});
newPosition = position.move(200, 100, [110 220]);
assertFalse(position.isOutOfImage());
assertTrue(newPosition.isOutOfImage());

function testAddsPatchesToUpdateItsTemplate
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
position = position.addPatches({Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertEqual([2 1], size(position.patches));

function testAddsPatchesThatCoverTheSameAreaOnlyOnce
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
position = position.addPatches({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))});
assertEqual([1 1], size(position.patches));

function testCollidesWithAnAreaIfOneOfItsAreasCollideWithIt
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(position.collidesWith(Area.fromXYtoXY(2, 3, 3, 4)));
assertFalse(position.collidesWith(Area.fromXYtoXY(4, 5, 5, 6)));

function testCollidesWithAnotherObjectIfOneOfItsAreasCollideWithIt
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2)); Patch(NaN, Area.fromXYtoXY(1, 3, 2, 4))});
assertTrue(position.collidesWithObject(position));
assertTrue(position.collidesWithObject(ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 2, 3, 4))})));
assertFalse(position.collidesWithObject(ObjectSighting({Patch(NaN, Area.fromXYtoXY(10, 10, 12, 12))})));

function testCollidesWithAnotherObjectIfIsConnectedToIt
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(11, 21, 20, 30))});
eastPosition = ObjectSighting({Patch(NaN, Area.fromXYtoXY(11, 31, 20, 40))});
southPosition = ObjectSighting({Patch(NaN, Area.fromXYtoXY(21, 21, 30, 30))});
assertTrue(position.collidesWithObject(eastPosition));
assertTrue(position.collidesWithObject(southPosition));

function testFilterItsPatchesBasedOnAnAreaFilter
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 10, 10)); Patch(NaN, Area.fromXYtoXY(11, 1, 20, 10))});
filter = SouthAreaFilter();
newPosition = position.filter(filter);
assertEqual([1 1], size(newPosition.patches));

function testFiltersAlsoItsDisplacementWhenTransformingTheAreas
position = ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 10, 10))}, [3 4]);
filter = RectificationAreaFilter(getDilationTForm(2));
newPosition = position.filter(filter);
assertEqual(int16([6 8]), newPosition.displacementFromPrevious);

function T = getDilationTForm(factor)
coordinates = [0 0; 1 1; 0 1; 1 0];
T = maketform('projective', coordinates, coordinates * factor);
