function test_suite = testObjectClusters
initTestSuite;

function testDetectCollisionOfTwoObjectsInTheSameFrame
obj1 = Object({getPosition(100, 200)}, [1]);
obj2 = Object({getPosition(101, 202)}, [1]);
cluster = ObjectCluster({obj1; obj2});
clusters = ObjectClusters({cluster});
collidedObjects = clusters.detectCollisions();
assertEqual([2 1], size(collidedObjects));

function p = getPosition(pointX, pointY)
p = ObjectPosition({Area.aroundPoint(pointX, pointY)}, [0 0]);
