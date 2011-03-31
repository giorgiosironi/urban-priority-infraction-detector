function test_suite = testObjectMatcher
initTestSuite;

function testMatchesObjectsFromTwoDifferentFramesAccordingToDissimilarityStrategy
matcher = ObjectMatcher(CornersObjectDistanceStrategy());
object1InFirst = ObjectSighting.newSighting({Area.fromXYtoXY(1, 1, 10, 10)});
object2InFirst = ObjectSighting.newSighting({Area.fromXYtoXY(100, 100, 110, 110)});
object3InFirst = ObjectSighting.newSighting({Area.fromXYtoXY(50, 150, 60, 160)});
object1InSecond = ObjectSighting.newSighting({Area.fromXYtoXY(11, 11, 20, 20)});
object2InSecond = ObjectSighting.newSighting({Area.fromXYtoXY(110, 110, 120, 120)});
object3InSecond = ObjectSighting.newSighting({Area.fromXYtoXY(60, 160, 70, 170)});
objectsInFirst = {object1InFirst; object2InFirst; object3InFirst};
objectsInSecond = {object2InSecond; object3InSecond; object1InSecond};
result = matcher.match(objectsInFirst, objectsInSecond);
assertEqual({object1InFirst object1InSecond; object2InFirst object2InSecond; object3InFirst object3InSecond}, result);
