function test_suite = testLabelsContainer
initTestSuite;

function testMergesTwoLabelsWhichAreDeclaredEquivalent
container = LabelsContainer(1, 2);
firstLabel = container.newLabel();
container.label(1, 1, firstLabel);
secondLabel = container.newLabel();
container.label(1, 2, secondLabel);
container.unionOf(firstLabel, secondLabel);
labels = container.getLabels();
assertEqual([1 1], size(labels));
positions = labels{1};
assertEqual([1 1; 1 2], positions);

function testMergesTwoLabelsWhichAreDeclaredEquivalentMultipleTimes
container = LabelsContainer(1, 2);
firstLabel = container.newLabel();
container.label(1, 1, firstLabel);
secondLabel = container.newLabel();
container.label(1, 2, secondLabel);
container.unionOf(firstLabel, secondLabel);
container.unionOf(secondLabel, firstLabel);
labels = container.getLabels();
assertEqual([1 1], size(labels));
positions = labels{1};
assertEqual([1 1; 1 2], positions);

function testMergesMultipleLabelsWhichAreDeclaredEquivalent
container = LabelsContainer(2, 2);
firstLabel = container.newLabel();
container.label(1, 1, firstLabel);
secondLabel = container.newLabel();
container.label(1, 2, secondLabel);
container.unionOf(firstLabel, secondLabel);
thirdLabel = container.newLabel();
container.label(2, 1, thirdLabel);
container.unionOf(thirdLabel, container.at(1, 2));
container.label(2, 2, container.newLabel());
container.unionOf(16, 23);
labels = container.getLabels();
assertEqual([2 1], size(labels));
positions = labels{1};
assertEqual([3 2], size(positions));
positions = labels{2};
assertEqual([1 2], size(positions));

