function test_suite = testObjectFinder
initTestSuite;

function testProducesAListOfObjectsEachComposedByAreas
finder = ObjectFinder(PatchesSelector(10, 10), ForegroundHistogramStrategy(), 1, LabelsContainerFactory());
content = ones(100) * -1;
content(11:20, 11:40) = ones(10, 30);
content(11:50, 51:60) = ones(40, 10);
objects = finder.findIn(Frame(content));
assertEqual([2 1], size(objects));
assertEqual([3 1], size(objects{1}.patches));
assertTrue(11 == objects{1}.patches{1}.area.minY);
assertTrue(21 == objects{1}.patches{2}.area.minY);
assertTrue(31 == objects{1}.patches{3}.area.minY);
assertEqual([4 1], size(objects{2}.patches));

function testMergesObjectsWithNorthAndWestProtuberances
finder = ObjectFinder(PatchesSelector(10, 10), ForegroundHistogramStrategy(), 1, LabelsContainerFactory());
content = ones(100) * -1;
content(31:40, 11:40) = ones(10, 30);
content(11:40, 31:40) = ones(30, 10);
objects = finder.findIn(Frame(content));
assertEqual([1 1], size(objects));
assertEqual([5 1], size(objects{1}.patches));
