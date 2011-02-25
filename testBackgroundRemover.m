function test_suite = testBackgroundRemover
initTestSuite

function testSetsToBlackAllBackgroundPixels
video = ones(20, 10, 1, 3);
video(1, 1, 1, 2) = 2;
video(2, 2, 1, 3) = 2;
remover = BackgroundRemover(0);
result = remover.filter(video);
% empty frame
assertEqual(zeros(20, 10, 1), result(:, :, :, 1));
% corner in second frame
assertEqual(0, result(1, 2, 1, 2));
assertEqual(2, result(1, 1, 1, 2));
% pixel next to the corner in third frame
assertEqual(0, result(1, 2, 1, 3));
assertEqual(2, result(2, 2, 1, 3));

function testBackgroundPixelsAreWithinADistanceFromBackgroundValue
video = ones(20, 10, 1, 3) * 40;
video(1, 1, 1, 2) = 42;
video(1, 2, 1, 2) = 39;
video(2, 2, 1, 3) = 42;
video(1, 2, 1, 3) = 41;
remover = BackgroundRemover(1);
result = remover.filter(video);
% empty frame
assertEqual(zeros(20, 10, 1), result(:, :, :, 1));
% corner in second frame
assertEqual(0, result(1, 2, 1, 2));
assertEqual(42, result(1, 1, 1, 2));
% pixel next to the corner in third frame
assertEqual(0, result(1, 2, 1, 3));
assertEqual(42, result(2, 2, 1, 3));

function testBackgroundPixelsCanBeSetToCustomValues
video = ones(20, 10, 1, 3);
video(1, 1, 1, 2) = 2;
video(2, 2, 1, 3) = 2;
remover = BackgroundRemover(0, -1);
result = remover.filter(video);
% empty frame
assertEqual(ones(20, 10, 1) * -1, result(:, :, :, 1));
assertEqual(-1, result(1, 2, 1, 2));
assertEqual(-1, result(1, 2, 1, 3));


