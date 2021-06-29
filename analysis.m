clear;
data = readtable("/Users/stevenseiden/PycharmProjects/eyeCursorTrack/timeTest.xlsx");

eyesX = data{1:end,1};
eyesY = data{1:end,2};

pts = linspace(0, 1, 101);
N = histcounts2(eyesY(:), eyesX(:), pts, pts);


subplot(1, 2, 1);
scatter(eyesX, eyesY, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));

% Plot heatmap:
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
