classdef PriorityRules < handle
    properties
        objectWithPriorityPositionFilter;
        priorities;
    end
    methods
        function obj = PriorityRules(filter)
            obj.objectWithPriorityPositionFilter = filter;
            obj.priorities = [];
        end
        function addPriority(self, hasPriority, givesPriority)
            self.priorities = [self.priorities; hasPriority givesPriority];
        end
        function collisions = detectCollisions(self, clusters)
            collisions = {};
            for k=1:self.priorities
                hasPriority = clusters{self.priorities(k, 1)};
                givesPriority = clusters{self.priorities(k, 2)};
                for i=1:size(hasPriority.objects, 1)
                    for j=1:size(givesPriority.objects, 1)
                        priorityObject = hasPriority.objects{i};
                        projectedObject = priorityObject.filterPositions(self.objectWithPriorityPositionFilter);
                        intersectingObject = givesPriority.objects{j};
                        if (projectedObject.collidesWith(intersectingObject))
                            collisions = [collisions; {priorityObject intersectingObject}];
                        end
                    end
                end
            end
        end
    end
end
