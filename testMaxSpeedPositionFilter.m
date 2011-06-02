function test_suite = testMaxSpeedPositionFilter
initTestSuite;

function testProjectsNextPositionsAtMaximumSpeed
filter = MaxSpeedPositionFilter();
positions = {getPosition([0 0], [0 0]); getPosition([100 0], [100 0]); getPosition([150 0], [50 0])};
positions = filter.filterPositions(positions);
expected = {getPosition([0 0], [0 0]); getPosition([100 0], [100 0]); getPosition([200 0], [100 0])};
assertEqual(expected, positions);

function testMaintainsOldDirectionsOfTheDisplacements
filter = MaxSpeedPositionFilter();
positions = {getPosition([0 0], [0 0]); getPosition([100 0], [100 0]); getPosition([100 100], [0 100])};
expected = positions;
positions = filter.filterPositions(positions);
assertEqual(expected, positions);

function testCorrectionsInPositionsAndDisplacementAreCumulative
filter = MaxSpeedPositionFilter();
positions = {getPosition([0 0], [0 0]); getPosition([100 0], [100 0]); getPosition([150 0], [50 0]); getPosition([180 0], [30 0])};
positions = filter.filterPositions(positions);
expected = {getPosition([0 0], [0 0]); getPosition([100 0], [100 0]); getPosition([200 0], [100 0]); getPosition([300 0], [100 0])};
assertEqual(expected, positions);

function p = getPosition(basePosition, displacement)
p = ObjectPosition({Area.aroundPoint(basePosition(1), basePosition(2))}, displacement);



