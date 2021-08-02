clear
close all

names = ["lookingleft","lookingright"];
datasize = 30;
X_train = zeros(datasize*length(names)/2,50);
Y_train = strings(datasize*length(names)/2,1);
X_test = zeros(datasize*length(names)/2,50);
Y_test = strings(datasize*length(names)/2,1);

count_train = 0;
count_test = 0;
for n = 1:length(names)
    loadDir = strcat('/Users/stevenseiden/PycharmProjects/eyeCursorTrack/data/',names(n),'/');
    Files = dir(strcat(loadDir,'*.txt'));
    
    for i = 1:datasize
        data = readtable(strcat(loadDir,Files(i).name));
        data_x = data{:,1};
        data_y = data{:,2};
        if i < 16
            count_train = count_train + 1;
            X_train(count_train,:) = interp1(data_x,[1:28.5/50:29]);
            Y_train(count_train,:) = names(n);
        else
            count_test = count_test + 1;
            X_test(count_test,:) = interp1(data_x,[1:28.5/50:29]);
            Y_test(count_test,:) = names(n);
        end
    end
end

model = fitcknn(X_train,Y_train,'NumNeighbors',3,'Standardize',1);
Y_predict = predict(model,X_test);
mean(Y_predict == Y_test)