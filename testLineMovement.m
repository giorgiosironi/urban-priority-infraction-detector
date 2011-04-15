function test_suite = testLineMovement
initTestSuite;

function testUniformsDisplacements
positions = {displacedOnXPosition(5); displacedOnXPosition(11); displacedOnXPosition(5)};
movement = LineMovement(3);
positions = movement.removeNoise(positions);
assertXDisplacementIs(5, positions{1});
assertXDisplacementIs((11+5+5)/3, positions{2});
assertXDisplacementIs(5, positions{3});

function testUniformsDisplacementsOverAVariableWindow
positions = {displacedOnXPosition(5); displacedOnXPosition(5); displacedOnXPosition(10); displacedOnXPosition(5); displacedOnXPosition(5)};
movement = LineMovement(5);
positions = movement.removeNoise(positions);
assertXDisplacementIs((10+5*4)/5, positions{3});

function testMovesPatchesToFollowDisplacementAdjustment
positions = {displacedOnXPosition(5); NaN; displacedOnXPosition(5)};
positions{2} = ObjectPosition({Area.singlePoint(100, 0)}, [11 0]);
movement = LineMovement(3);
positions = movement.removeNoise(positions);
assertTrue(positions{2}.areas{1}.equals(Area.singlePoint(100-4, 0)));

function p = displacedOnXPosition(x)
p = ObjectPosition({Area.singlePoint(1, 1)}, [x 0]);

function assertXDisplacementIs(x, position)
assertEqual(int16(x), int16(position.displacementFromPrevious(1)));
