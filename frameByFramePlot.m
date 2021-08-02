clear;

data = readtable("/Users/stevenseiden/PycharmProjects/eyeCursorTrack/lookingleft/left1.txt");

eyesX = data{1:end,1};
eyesY = data{1:end,2};
opts = statset('Display','final');

plot(eyesY)

plot(eyesX([1:10]),eyesY([1:10]),'.')

for i = 1 : length(eyesX)
    plotimg = plot(eyesX(i),eyesY(i),'.','MarkerSize',20);
    set(gca,'Ydir','reverse')
    axis([0 1 .5 1])
    saveas(plotimg,sprintf('plot%d.jpg',i))
end