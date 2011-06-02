function test_suite = testRectificationAreaFilter
initTestSuite;

function testChangeTheCoordinatesOfAreas
filter = RectificationAreaFilter(getDilation(2));
areas = {Area.aroundPoint(20, 30)};
newAreas = filter.filterAreas(areas);
assertEqual([1 1], size(newAreas));
assertEqual(Area.fromXYtoXY(30, 50, 48, 68), newAreas{1});

function T = getDilation(factor)
from = [0 0; 0 100; 100 100; 100 0];
to = from * factor;
T = maketform('projective', from, to);
