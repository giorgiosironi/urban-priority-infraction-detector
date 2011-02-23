function test_suite = testVoteMap
initTestSuite;

function testSumsASeriesOfMaps
first = VoteMap();
first.vote(0, 0, 1);
first.vote(1, 1, 2);
second = VoteMap();
second.vote(0, 0, 3);
second.vote(1, 1, 4);
map = VoteMap.sum({first; second});
assertEqual([0 0; 1 1], map.offsets);
assertEqual([4; 6], map.distances);

function testSumsASeriesOfMapsWithAThresholdForContribution
first = VoteMap();
first.vote(0, 0, 1);
first.vote(1, 1, 2);
second = VoteMap();
second.vote(0, 0, 3);
second.vote(1, 1, 104);
map = VoteMap.sum({first; second}, 10);
assertEqual([0 0; 1 1], map.offsets);
assertEqual([4; 12], map.distances);

