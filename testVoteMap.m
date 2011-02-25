function test_suite = testVoteMap
initTestSuite;

function testCombinesASeriesOfMapsBySum
first = VoteMap();
first.vote(0, 0, 1);
first.vote(1, 1, 2);
second = VoteMap();
second.vote(0, 0, 3);
second.vote(1, 1, 4);
map = VoteMap.combine({first; second}, VoteMapSumStrategy());
assertEqual([0 0; 1 1], map.offsets);
assertEqual([4; 6], map.distances);

function testCombinesASeriesOfMapsBySumWithAThresholdForContribution
first = VoteMap();
first.vote(0, 0, 1);
first.vote(1, 1, 2);
second = VoteMap();
second.vote(0, 0, 3);
second.vote(1, 1, 104);
map = VoteMap.combine({first; second}, VoteMapThresholdStrategy(10));
assertEqual([0 0; 1 1], map.offsets);
assertEqual([4; 12], map.distances);

function testCombinesASeriesOfMapsBySumByChoosingTheValueAtTheGivenPercentile
first = VoteMap();
first.vote(0, 0, 3);
first.vote(1, 1, 104);
second = VoteMap();
second.vote(0, 0, 1);
second.vote(1, 1, 40);
third = VoteMap();
third.vote(0, 0, 30);
third.vote(1, 1, 2);
fourth = VoteMap();
fourth.vote(0, 0, 30);
fourth.vote(1, 1, 10);
fifth = VoteMap();
fifth.vote(0, 0, 20);
fifth.vote(1, 1, 50);
map = VoteMap.combine({first; second; third; fourth; fifth}, VoteMapPercentileStrategy(25));
assertEqual([0 0; 1 1], map.offsets);
assertEqual([1; 2], map.distances);


