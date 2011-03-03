for i=1:size(objects, 1)
    for j=1:size(objects{i}.patches, 1)
        area = objects{i}.patches{j}.area;
        hold on;
        centroid = area.getCentroid();
        plot(centroid(2), centroid(1), 'rx');
    end
end
