function test_suite = testTrajectory
initTestSuite;

function testCalculatesFitnessOfACertainObjectByCollidingThemWithPredefinedAreas
object = getObjectThatPassedFrom(Area.fromXYtoXY(1, 1, 10, 10));
trajectory = Trajectory({Area.fromXYtoXY(8, 8, 9, 9)});
assertEqual(1, trajectory.getFitness(object));
assertEqual(0, trajectory.getFitness(getObjectThatPassedFrom(Area.fromXYtoXY(100, 100, 200, 200))));

function testFitnessOfAnObjectIsThePercentageOfAreasTouched()
object = getObjectThatPassedFrom(Area.fromXYtoXY(1, 1, 10, 10));
trajectory = Trajectory({Area.fromXYtoXY(8, 8, 9, 9); Area.fromXYtoXY(100, 100, 200, 100)});
assertEqual(0.5, trajectory.getFitness(object));

function object = getObjectThatPassedFrom(area)
object = Object({{TrackedObjectPosition({Patch(NaN, area)})}}, [1]);
