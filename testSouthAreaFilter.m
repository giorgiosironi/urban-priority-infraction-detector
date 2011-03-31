function test_suite = testSouthAreaFilter
initTestSuite;

function testRemovesAreasWhichAreNotOnThePavement
filter = SouthAreaFilter();
areas = {Area.aroundPoint(15, 5); Area.aroundPoint(25, 5)};
newAreas = filter.filterAreas(areas);
assertEqual([1 1], size(newAreas));

function testRemovesMultipleAreasWhichAreNotOnThePavement
filter = SouthAreaFilter();
areas = {Area.aroundPoint(15, 5); Area.aroundPoint(25, 5); Area.aroundPoint(35, 5)};
areas = [areas; {Area.aroundPoint(15, 15); Area.aroundPoint(25, 15); Area.aroundPoint(35, 15)}];

newAreas = filter.filterAreas(areas);
assertEqual([2 1], size(newAreas));
assertEqual(int16([35 5]), newAreas{1}.getCentroid());
assertEqual(int16([35 15]), newAreas{2}.getCentroid());
