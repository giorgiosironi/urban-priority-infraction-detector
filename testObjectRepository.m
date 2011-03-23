function test_suite = testObjectRepository
initTestSuite;

function testInitializesItselfFromSomePositions
position1 = TrackedObjectPosition({Patch(NaN, NaN)});
position2 = TrackedObjectPosition({Patch(NaN, NaN)});
repository = ObjectRepository();
repository.initializeObjects({position1; position2}, 40);
assertEqual([2 1], size(repository.objects));
