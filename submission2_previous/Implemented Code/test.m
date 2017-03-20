clear all;
clc;

%% Import Image %% Make Image corrupted
RGB = imread('.\data\2.jpg');% convert given file into RGB
RGB = imnoise(RGB,'salt & pepper',0.02);
t = rgb2gray(RGB);% convert RGB file into gray image
t = im2double(t);% convert uint8 value to double for computation

%% require principal axes
k = 200;

%% Apply PPCA on data corrupted data matrix
[W,sigma_square,Xn,t_mean,M] = em_ppca(t,k);

%% Apply PPCA with Expectation Maximization Algorithm
[W_,sigma_square_,Xn_,t_mean_] = ppca(t,k);

%% Recovered Image
rec_Image = W*inv(W'*W)*M*Xn;
rec_Image = rec_Image + (t_mean)*ones(1,size(rec_Image,2));

imshow(im2uint8(rec_Image));