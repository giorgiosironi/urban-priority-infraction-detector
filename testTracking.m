function test_suite = testObjectTracking
initTestSuite;

function testTracksObjectsBetweenTwoFrames
frames = cell(2, 1);
frames{1} = Frame.fromFile('frames/image40.jpg');
frames{2} = Frame.fromFile('frames/image41.jpg');

tracker = PointObjectTracker.getInstance();
objects = tracker.getMovingObjects();
assertTrue(iscell(objects));
frames = objects{1}.frames;
assertEquals([1; 2], frames);
centroid = objects{1}.centroid;
assertTrue(centroid.x > 130 && centroid.x < 280);
assertTrue(centroid.y > 50 && centroid.y < 300);
