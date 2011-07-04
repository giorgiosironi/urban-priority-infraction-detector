function test_suite = testObjectRepository
initTestSuite;

function testInitializesItselfFromSomePositions
position1 = ObjectSighting.newSighting({Patch(NaN, NaN)});
position2 = ObjectSighting.newSighting({Patch(NaN, NaN)});
repository = ObjectRepository();
repository.initializeObjects({position1; position2}, 40);
assertEqual([2 1], size(repository.objects));

function testTracksMovingObjectsBetweenFrames
repository = ObjectRepository();
oldPosition = ObjectSighting.newSighting({Patch(NaN, NaN)});
repository.initializeObjects({oldPosition}, 40);
newPosition = ObjectSighting.newSighting({Patch(NaN, NaN)});
repository.trackObjects({oldPosition}, {newPosition}, 41);
assertEqual([1 1], size(repository.objects));
assertEqual([2 1], size(repository.objects{1}.frames));

function testAddsNewObjectsToTheStorage
repository = ObjectRepository();
repository.initializeObjects({}, 40);
newPosition = ObjectSighting.newSighting({Patch(NaN, NaN)});
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
assertEqual('ObjectClusters', class(objectsByTrajectory));
assertEqual([2 1], objectsByTrajectory.size());
firstCluster = objectsByTrajectory.at(1);
assertEqual('ObjectCluster', class(firstCluster));
assertEqual([1 1], firstCluster.size());
assertEqual([1 1], objectsByTrajectory.at(2).size());

function testDoesNotExplodewhenObjectsDoNotPertainToAnyTrajectory
repository = ObjectRepository();
oldPosition = getPosition(Area.fromXYtoXY(51, 51, 60, 60));
repository.initializeObjects({oldPosition}, 40);
repository.trackObjects({oldPosition}, {oldPosition}, 41);
trajectories = {};
objectsByTrajectory = repository.clusterObjects(trajectories);
assertEqual('ObjectClusters', class(objectsByTrajectory));
assertEqual([0 0], objectsByTrajectory.size());


function t = getTrajectoryBetweenTwoAreas(first, second)
t = Trajectory({first; second});

function p = getPosition(area)
p = ObjectSighting.newSighting({Patch(NaN, area)});
