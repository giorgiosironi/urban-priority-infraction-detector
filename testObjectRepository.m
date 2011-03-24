function test_suite = testObjectRepository
initTestSuite;

function testInitializesItselfFromSomePositions
position1 = TrackedObjectPosition({Patch(NaN, NaN)});
position2 = TrackedObjectPosition({Patch(NaN, NaN)});
repository = ObjectRepository();
repository.initializeObjects({position1; position2}, 40);
assertEqual([2 1], size(repository.objects));

function testTracksMovingObjectsBetweenFrames
repository = ObjectRepository();
oldPosition = TrackedObjectPosition({Patch(NaN, NaN)});
repository.initializeObjects({oldPosition}, 40);
newPosition = TrackedObjectPosition({Patch(NaN, NaN)});
repository.trackObjects({oldPosition}, {newPosition}, 41);
assertEqual([1 1], size(repository.objects));
assertEqual([2 1], size(repository.objects{1}.frames));

function testAddsNewObjectsToTheStorage
repository = ObjectRepository();
repository.initializeObjects({}, 40);
newPosition = TrackedObjectPosition({Patch(NaN, NaN)});
repository.trackObjects({}, {newPosition}, 41);
assertEqual([1 1], size(repository.objects));

function testClustersObjectByTrajectory
repository = ObjectRepository();
center = Area.fromXYtoXY(51, 51, 60, 60);
northWest = Area.fromXYtoXY(1, 1, 10, 10);
northEast = Area.fromXYtoXY(1, 101, 10, 110);
oldPosition = getPosition(center);
repository.initializeObjects({oldPosition; oldPosition}, 40);
repository.trackObjects({oldPosition; oldPosition}, {getPosition(northWest); getPosition(northEast)}, 41);
trajectories = {getTrajectoryBetweenTwoAreas(center, northWest); getTrajectoryBetweenTwoAreas(center, northEast)};
objectsByTrajectory = repository.clusterObjects(trajectories);
assertEqual([2 1], size(objectsByTrajectory));
assertEqual([1 1], size(objectsByTrajectory{1}));
assertEqual([1 1], size(objectsByTrajectory{2}));

function t = getTrajectoryBetweenTwoAreas(first, second)
t = Trajectory({first; second});

function p = getPosition(area)
p = TrackedObjectPosition({Patch(NaN, area)});
