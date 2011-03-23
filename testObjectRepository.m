function test_suite = testObjectRepository
initTestSuite;

function testInitializesItselfFromSomePositions
position1 = TrackedObjectPosition({Patch(NaN, NaN)});
position2 = TrackedObjectPosition({Patch(NaN, NaN)});
repository = ObjectRepository();
repository.initializeObjects({position1; position2}, 40);
assertEqual([2 1], size(repository.objects));

function testAddsNewObjectsToTheStorage
repository = ObjectRepository();
oldPosition = TrackedObjectPosition({Patch(NaN, NaN)});
repository.initializeObjects({oldPosition}, 40);
newPosition = TrackedObjectPosition({Patch(NaN, NaN)});
repository.trackObjects({oldPosition}, {newPosition}, 41);
assertEqual([1 1], size(repository.objects));
assertEqual([2 1], size(repository.objects{1}.frames));
