function test_suite = testPatchesSelector
initTestSuite;

function testCalculatesASingleAreaFromTheOriginalOne
selector = PatchesSelector(1, 1);
definitions = selector.getPatchDefinitions(Area.fromXYtoXY(1, 2, 10, 11));
assertEqual([1 1], size(definitions));
assertEqual(1, definitions{1}.minX);
assertEqual(2, definitions{1}.minY);
assertEqual(10, definitions{1}.maxX);
assertEqual(11, definitions{1}.maxY);

function testCalculatesACoupleOfAreasForDividingTheAreaAlongTheXAxis
selector = PatchesSelector(2, 1);
definitions = selector.getPatchDefinitions(Area.fromXYtoXY(1, 11, 10, 20));
assertEqual([2 1], size(definitions));
assertEqual(1, definitions{1}.minX);
assertEqual(11, definitions{1}.minY);
assertEqual(5, definitions{1}.maxX);
assertEqual(20, definitions{1}.maxY);
assertEqual(6, definitions{2}.minX);
assertEqual(11, definitions{2}.minY);
assertEqual(10, definitions{2}.maxX);
assertEqual(20, definitions{2}.maxY);

function testCalculatesACoupleOfAreasForDividingTheAreaAlongTheYAxis
selector = PatchesSelector(1, 2);
definitions = selector.getPatchDefinitions(Area.fromXYtoXY(1, 11, 10, 20));
assertEqual([2 1], size(definitions));
assertEqual(1, definitions{1}.minX);
assertEqual(11, definitions{1}.minY);
assertEqual(10, definitions{1}.maxX);
assertEqual(15, definitions{1}.maxY);
assertEqual(1, definitions{2}.minX);
assertEqual(16, definitions{2}.minY);
assertEqual(10, definitions{2}.maxX);
assertEqual(20, definitions{2}.maxY);

function testRoundsTheLastPatchesInOrderToFillOriginatingAreaExactly
selector = PatchesSelector(2, 2);
definitions = selector.getPatchDefinitions(Area.fromXYtoXY(1, 11, 9, 19));
assertEqual([4 1], size(definitions));
assertEqual(19, definitions{2}.maxY);
assertEqual(9, definitions{3}.maxX);
assertEqual(9, definitions{4}.maxX);
assertEqual(19, definitions{4}.maxY);
