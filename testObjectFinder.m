function test_suite = testObjectFinder
initTestSuite;

function testProducesAListOfObjectsEachComposedByAreas
finder = ObjectFinder(PatchesSelector(10, 10), ForegroundHistogramStrategy(), 1, LabelsContainerFactory());
content = ones(100) * -1;
content(11:20, 11:40) = ones(10, 30);
content(11:50, 51:60) = ones(40, 10);
objects = finder.findIn(Frame(content));
assertEqual([2 1], size(objects));
assertEqual([3 1], size(objects{1}.areas));
assertEqual(11, objects{1}.areas{1}.minY);
assertEqual(21, objects{1}.areas{2}.minY);
assertEqual(31, objects{1}.areas{3}.minY);
assertEqual([4 1], size(objects{2}.areas));

function testMergesObjectsWithNorthAndWestProtuberances
finder = ObjectFinder(PatchesSelector(10, 10), ForegroundHistogramStrategy(), 1, LabelsContainerFactory());
content = ones(100) * -1;
content(31:40, 11:40) = ones(10, 30);
content(11:40, 31:40) = ones(30, 10);
objects = finder.findIn(Frame(content));
assertEqual([1 1], size(objects));
assertEqual([5 1], size(objects{1}.areas));
