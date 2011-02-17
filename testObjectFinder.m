function test_suite = testObjectFinder
initTestSuite;

function testMatchesPointsWithCommonMotion
frames = cell(2, 1);
frames{1} = 0;
frames{2} = 0;

movements = cell(3, 1);
movements{1} = Track.fromXYtoXY(2, 2, 4, 5);
movements{2} = Track.fromXYtoXY(12, 12, 14, 15);
movements{3} = Track.fromXYtoXY(12, 12, 40, 10);
mockTracker = StubFeatureTracker(frames, movements);

expectedObjects = cell(1);
expectedObjects{1} = MovingObject([1; 2], {});
mockGrouper = StubTrackGrouper(movements, expectedObjects);

finder = ObjectFinder(mockTracker, mockGrouper);
objects = finder.getMovingObjects(frames);
assertEqual(expectedObjects, objects);

% should be in TrackGrouper
%assertTrue(iscell(objects));
%assertEqual([1 1], size(objects));
%frames = objects{1}.frames;
%assertEqual([1; 2], frames);
%
%centroids = objects{1}.centroids;
%for i=1:2
%    centroid = centroids{i};
%    assertTrue(centroid.x > 2 && centroid.x < 12);
%    assertTrue(centroid.y > 50 && centroid.y < 300);
%end
