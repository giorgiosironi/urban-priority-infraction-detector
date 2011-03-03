function test_suite = testPatchesSelector
initTestSuite;

function testCalculatesASingleAreaFromTheOriginalOne
selector = PatchesSelector(1, 1);
group = selector.getAreaGroup(Area.fromXYtoXY(1, 2, 10, 11));
assertEqual([1 1], group.size());
assertTrue(1 == group.at(1, 1).minX);
assertTrue(2 == group.at(1, 1).minY);
assertTrue(10 == group.at(1, 1).maxX);
assertTrue(11 == group.at(1, 1).maxY);

function testCalculatesACoupleOfAreasForDividingTheAreaAlongTheXAxis
selector = PatchesSelector(2, 1);
group = selector.getAreaGroup(Area.fromXYtoXY(1, 11, 10, 20));
assertEqual([2 1], group.size());
assertTrue(1 == group.at(1, 1).minX);
assertTrue(11 == group.at(1, 1).minY);
assertTrue(5 == group.at(1, 1).maxX);
assertTrue(20 == group.at(1, 1).maxY);
assertTrue(6 == group.at(2, 1).minX);
assertTrue(11 == group.at(2, 1).minY);
assertTrue(10 == group.at(2, 1).maxX);
assertTrue(20 == group.at(2, 1).maxY);

function testCalculatesACoupleOfAreasForDividingTheAreaAlongTheYAxis
selector = PatchesSelector(1, 2);
group = selector.getAreaGroup(Area.fromXYtoXY(1, 11, 10, 20));
assertEqual([1 2], group.size());
assertTrue(1 == group.at(1, 1).minX);
assertTrue(11 == group.at(1, 1).minY);
assertTrue(10 == group.at(1, 1).maxX);
assertTrue(15 == group.at(1, 1).maxY);
assertTrue(1 == group.at(1, 2).minX);
assertTrue(16 == group.at(1, 2).minY);
assertTrue(10 == group.at(1, 2).maxX);
assertTrue(20 == group.at(1, 2).maxY);

function testRoundsTheLastPatchesInOrderToFillOriginatingAreaExactly
selector = PatchesSelector(2, 2);
group = selector.getAreaGroup(Area.fromXYtoXY(1, 11, 9, 19));
assertEqual([2 2], group.size());
assertTrue(19 == group.at(1, 2).maxY);
assertTrue(9 == group.at(2, 1).maxX);
assertTrue(9 == group.at(2, 2).maxX);
assertTrue(19 == group.at(2, 2).maxY);

function testWorksWithRealVideoDimensions
selector = PatchesSelector(48, 64);
group = selector.getAreaGroup(Area.fromXYtoXY(1, 1, 480, 640));
assertEqual([48 64], group.size());
