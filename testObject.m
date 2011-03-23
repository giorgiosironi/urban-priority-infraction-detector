function test_suite = testObject
initTestSuite;

function testInitializesItselfFromATrackedObjectPosition
area = Area.fromXYtoXY(1, 1, 10, 10);
position = TrackedObjectPosition({Patch(NaN, area)});
obj = Object.fromKnownPosition(position, 40);
assertEqual([1 1], size(obj.positions));
positions = obj.positions{1};
assertEqual(area, positions{1});
assertEqual(40, obj.frames(1));

function testStoresMoreThanOnePosition
area = Area.fromXYtoXY(1, 1, 10, 10);
position = TrackedObjectPosition({Patch(NaN, area)});
obj = Object({}, []);
obj.addKnownPosition(position, 40);
obj.addKnownPosition(position, 41);
assertEqual([2 1], size(obj.positions));
assertEqual([2 1], size(obj.frames));

function testDetectsIfItPassedFromAnArea
obj = Object({{Area.fromXYtoXY(1, 1, 10, 10)}; {Area.fromXYtoXY(100, 100, 200, 200)}}, [1; 2]);
assertTrue(obj.passedFrom(Area.fromXYtoXY(5, 5, 6, 6)));
assertTrue(obj.passedFrom(Area.fromXYtoXY(101, 105, 102, 106)));
assertFalse(obj.passedFrom(Area.fromXYtoXY(1, 105, 2, 106)));
assertFalse(obj.passedFrom(Area.fromXYtoXY(105, 1, 106, 2)));
