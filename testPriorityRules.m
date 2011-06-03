function test_suite = testObjectClusters
initTestSuite;

function testDetectCollisionOfTwoObjectsInTheSameFrame
obj1 = Object({getPosition(100, 200)}, [1]);
obj2 = Object({getPosition(101, 202)}, [1]);
cluster1 = ObjectCluster({obj1});
cluster2 = ObjectCluster({obj2});
clusters = {cluster1; cluster2};
priorityRules = PriorityRules(MaxSpeedPositionFilter());
priorityRules.addPriority(1, 2);
collidedObjects = priorityRules.detectCollisions(clusters);
assertEqual([1 2], size(collidedObjects));

function p = getPosition(pointX, pointY)
p = ObjectPosition({Area.aroundPoint(pointX, pointY)}, [0 0]);
