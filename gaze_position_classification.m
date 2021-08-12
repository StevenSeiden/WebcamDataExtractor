clear
close all

names = ["lookingleft","lookingcenter"];
datasize = 25;
datalength = 80;
X_train = zeros(floor(datasize/2)*length(names),datalength);
Y_train = strings(floor(datasize/2)*length(names),1);
X_test = zeros((datasize-floor(datasize/2))*length(names),datalength);
Y_test = strings((datasize-floor(datasize/2))*length(names),1);

% Using X-axis data
count_train = 0;
count_test = 0;
for n = 1:length(names)
    loadDir = strcat('/Users/stevenseiden/PycharmProjects/eyeCursorTrack/data/',names(n),'/');
    Files = dir(strcat(loadDir,'*.txt'));
    
    for i = 1:datasize
        rawdata = readtable(strcat(loadDir,Files(i).name));
        data = rawdata{:,1};
        if i < floor(datasize/2)+1
            count_train = count_train + 1;
            temp = interp1(data,[1:length(data)/datalength:length(data)]);
            if length(temp) < 80
                temp(1,length(temp)+1:80) = temp(length(temp)); 
            end
            X_train(count_train,:) = temp;
            Y_train(count_train,:) = names(n);
        else
            count_test = count_test + 1;
            temp = interp1(data,[1:length(data)/datalength:length(data)]);
            if length(temp) < 80
                temp(1,length(temp)+1:80) = temp(length(temp)); 
            end
            X_test(count_test,:) = temp;
            Y_test(count_test,:) = names(n);
        end
    end
end

% model = fitcknn(X_train,Y_train,'NumNeighbors',3,'Standardize',1);
model = fitcsvm(X_train,Y_train);
[Y_predict scores_x] = predict(model,X_test);
accuracy_x = mean(Y_predict == Y_test)


% Using Y-axis data
X_train = zeros(floor(datasize/2)*length(names),datalength);
Y_train = strings(floor(datasize/2)*length(names),1);
X_test = zeros((datasize-floor(datasize/2))*length(names),datalength);
Y_test = strings((datasize-floor(datasize/2))*length(names),1);

count_train = 0;
count_test = 0;
for n = 1:length(names)
    loadDir = strcat('/Users/stevenseiden/PycharmProjects/eyeCursorTrack/data/',names(n),'/');
    Files = dir(strcat(loadDir,'*.txt'));
    
    for i = 1:datasize
        rawdata = readtable(strcat(loadDir,Files(i).name));
        data = rawdata{:,2};
        if i < floor(datasize/2)+1
            count_train = count_train + 1;
            temp = interp1(data,[1:length(data)/datalength:length(data)]);
            if length(temp) < 80
                temp(1,length(temp)+1:80) = temp(length(temp)); 
            end
            X_train(count_train,:) = temp;
            Y_train(count_train,:) = names(n);
        else
            count_test = count_test + 1;
            temp = interp1(data,[1:length(data)/datalength:length(data)]);
            if length(temp) < 80
                temp(1,length(temp)+1:80) = temp(length(temp)); 
            end
            X_test(count_test,:) = temp;
            Y_test(count_test,:) = names(n);
        end
    end
end

% model = fitcknn(X_train,Y_train,'NumNeighbors',3,'Standardize',1);
model = fitcsvm(X_train,Y_train);
[Y_predict scores_y] = predict(model,X_test);
accuracy_y = mean(Y_predict == Y_test)

% integrate X- and Y-axis
scores_integrate = (scores_x+scores_y)/2;
Y_predict_integrate = strings(length(Y_predict),1);
for i = 1:length(Y_predict)
    if scores_integrate(i,1) < scores_integrate(i,2)
        Y_predict_integrate(i,1) = "lookingleft";
    else
        Y_predict_integrate(i,1) = "lookingcenter";
    end
end
accuracy_integrated = mean(Y_predict_integrate == Y_test)