% This is the top file.
clc;
clear all;
close all;

%fileI = fopen('semeion.txt','r');
%Vx = fscanf(fileI,'%f');
%fclose(fileI);
%data = reshape(Vx,[],266);
%Load data
data = load('semeion.data');
Xorig = data(:,1:256);
Yorig = data(:,257:end);
X =Xorig;
Y= Yorig;

% Shuffle the data
%random_order = randperm(size(Xorig,1));
%X = Xorig(random_order,:);
%Y = Yorig(random_order,:);

% Training data
X_train = X(1:1100,:);
Y_train = Y(1:1100,:);

% Testing data
X_test = X(1101:end,:);
Y_test = Y(1101:end,:);

% Hidden layer neurons
% Tweak it for optimization
hidden_neurons = 420;
dislay_varible=440;
% Training the model
[parameters, Ytrain_hat]= ELM_train(X_train,Y_train,hidden_neurons);
% Check training accuracy
train_acc = check_acc(Ytrain_hat,Y_train);

% Testing the model
Ytest_hat= ELM_test(X_test, parameters);
% Check training accuracy
test_acc = check_acc(Ytest_hat,Y_test);



%To show the the handwritten digit and accuracy
fprintf("hidden_neurons = %d \n",hidden_neurons)
fprintf("train accuracy for all 1100 inputs= %f \n",train_acc)
fprintf("test accuracy for all 493 inputs=  %f",test_acc)

digit = reshape(X_test(dislay_varible,:),16,16);
imshow(digit')
fprintf("desired output vector for row %d input in the test data =",dislay_varible)
disp(Y_test(dislay_varible,:))
fprintf("computed output vector for row %d input in the test data =",dislay_varible)
disp(Ytest_hat(dislay_varible,:))


   