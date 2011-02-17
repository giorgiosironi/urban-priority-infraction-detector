function test_suite = testFrame
initTestSuite;

function testCreatesItselfFromMatrix
frame = Frame(ones(2, 3));
assertEqual(ones(2,3), frame.content);

function testCreatesItselfFromImageFile
frame = Frame.fromFile('frames/image40.jpg');
assertEqual([480 640 3], size(frame.content));


