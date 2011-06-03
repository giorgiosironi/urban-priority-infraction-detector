function test_suite = testObject
initTestSuite;

function testInitializesItselfFromAObjectSighting
area = Area.fromXYtoXY(1, 1, 10, 10);
sighting = ObjectSighting.newSighting({Patch(NaN, area)});
obj = Object.fromKnownSighting(sighting, 40);
assertEqual([1 1], size(obj.positions));
positions = obj.positions{1};
assertEqual(area, positions.areas{1});
assertEqual(40, obj.frames(1));

function testStoresMoreThanOnePosition
area = Area.fromXYtoXY(1, 1, 10, 10);
sighting = ObjectSighting.newSighting({Patch(NaN, area)});
obj = Object({}, []);
obj.addKnownSighting(sighting, 40);
obj.addKnownSighting(sighting, 41);
assertEqual([2 1], size(obj.positions));
assertEqual([2 1], size(obj.frames));

function testDetectsIfItPassedFromAnArea
obj = Object({ObjectPosition({Area.fromXYtoXY(1, 1, 10, 10)}); ObjectPosition({Area.fromXYtoXY(100, 100, 200, 200)})}, [1; 2]);
assertTrue(obj.passedFrom(Area.fromXYtoXY(5, 5, 6, 6)));
assertTrue(obj.passedFrom(Area.fromXYtoXY(101, 105, 102, 106)));
assertFalse(obj.passedFrom(Area.fromXYtoXY(1, 105, 2, 106)));
assertFalse(obj.passedFrom(Area.fromXYtoXY(105, 1, 106, 2)));

function testDetectsCollisionWithAnotherObjectInASingleFrame
standardPositions = {ObjectPosition({Area.fromXYtoXY(1, 1, 10, 10)}); ObjectPosition({Area.fromXYtoXY(100, 100, 200, 200)})};
obj = Object(standardPositions, [1; 2]);
exactSameObject = Object(standardPositions, [1; 2]);
exactSameObjectButTwoFramesAfterwards = Object(standardPositions, [3; 4]);
assertTrue(obj.collidesWith(exactSameObject));
assertFalse(obj.collidesWith(exactSameObjectButTwoFramesAfterwards));


