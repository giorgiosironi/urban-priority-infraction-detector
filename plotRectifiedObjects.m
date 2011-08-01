function plotRectifiedObjects(clusters, frame)
for i=1:size(clusters.clusters, 1)
    for j=1:size(clusters.clusters{i}.objects, 1)
        object = clusters.clusters{i}.objects{j};
        position = object.positions{frame};
        hold on;
        for k=1:size(position.areas, 1)
            area = position.areas{k};
            centroid = area.getCentroid()
            plot(centroid(2), centroid(1), 'rx');
        end
    end
end
