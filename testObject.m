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
