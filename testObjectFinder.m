function test_suite = testObjectFinder
initTestSuite;

function testProducesAListOfObjectsEachComposedByAreas
finder = ObjectFinder(PatchesSelector(10, 10), ForegroundHistogramStrategy(), 1);
content = ones(100) * -1;
content(11:20, 11:40) = ones(10, 30);
content(11:40, 51:60) = ones(30, 10);
objects = finder.findIn(Frame(content));
assertEqual([2 1], size(objects));

function testMergesObjectsWithNorthAndWestProtuberances
finder = ObjectFinder(PatchesSelector(10, 10), ForegroundHistogramStrategy(), 1);
content = ones(100) * -1;
content(31:40, 11:40) = ones(10, 30);
content(11:40, 31:40) = ones(30, 10);
objects = finder.findIn(Frame(content));
assertEqual([1 1], size(objects));
