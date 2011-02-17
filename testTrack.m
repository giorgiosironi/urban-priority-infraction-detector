function test_suite = testTrack
initTestSuite

function testCanBeCreatedFromCoupleOfCartesianCoordinates
movement = Track.fromXYtoXY(1, 2, 3, 4);
assertEqual(1, movement.xProgression(1));
assertEqual(2, movement.yProgression(1));
assertEqual(3, movement.xProgression(2));
assertEqual(4, movement.yProgression(2));
