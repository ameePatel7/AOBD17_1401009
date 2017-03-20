clc;
clear;

%% Import Image %% Make Image corrupted
Original = imread('.\data\6.jpg');% convert given file into RGB
Original = rgb2gray(Original);
Original = im2double(Original);

t = Original;
t = imnoise(t,'salt & pepper', 0.02); % Corrupt image
%t(2:30:end) = NaN; % Missing image

%% require principal axes
k = 60;
itr = 20;

%% Apply PPCA with Expectation Maximization Algorithm on data corrupted data matrix
tic
[W,sigma_square,Xn,t_mean,M] = em_ppca(t,k,itr);
toc

%% Recovered Image
rec_Image = W*inv(W'*W)*M*Xn;
rec_Image = rec_Image + (t_mean)*ones(1,size(rec_Image,2));

error = Original - rec_Image;
RMS_error = sqrt(sum(sum(error.^2))/(size(t,1)*size(t,2)));
disp(RMS_error);

% figure;
% imshow(im2uint8(t));
% title('Corrupted Image');
% str1 = strcat('./Dump/',int2str(k),'_Latent_Variables_Corrupted_image','.jpg');
% imwrite(t,str1);
% 
% figure;
% imshow(im2uint8(rec_Image));
% title('Recovered Image');
% str1 = strcat('./Dump/',int2str(k),'_Latent_Variables_C_Recovered_image','.jpg');
% imwrite(rec_Image,str1);
% 
% 
% figure;
% imshow(im2uint8(Original));
% title('Original Image');
% str1 = strcat('./Dump/',int2str(k),'_Latent_Variables_Original_image','.jpg');
% imwrite(Original,str1);