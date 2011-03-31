function test_suite = testObjectPosition
initTestSuite;

function testFilterItsAreas
position = ObjectPosition({Area.fromXYtoXY(1, 1, 10, 10); Area.fromXYtoXY(11, 1, 20, 10)});
filter = SouthAreaFilter();
newPosition = position.filter(filter);
assertEqual([1 1], size(newPosition.areas));

function testFiltersAlsoItsDisplacementWhenTransformingTheAreas
position = ObjectPosition({Area.fromXYtoXY(1, 1, 10, 10)}, [3 4]);
filter = RectificationAreaFilter(getDilationTForm(2));
newPosition = position.filter(filter);
assertEqual(int16([6 8]), newPosition.displacementFromPrevious);

function T = getDilationTForm(factor)
coordinates = [0 0; 1 1; 0 1; 1 0];
T = maketform('projective', coordinates, coordinates * factor);
