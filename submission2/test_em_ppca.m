clc;
clear;

q = 30;
itr = 10;

% read image and add the mask
X = imread('./data/6.jpg');
X = rgb2gray(X);
X = im2double(X);

% X = imresize(X,0.4);
img = X;
img_corrupted = img;
img_corrupted = imnoise(img_corrupted,'salt & pepper',0.02);
%img_corrupted(2:30:end) = NaN;

fprintf(1, '%d corrupted entries\n', nnz(isnan(img_corrupted)));

% create a matrix X from overlapping patches
ws = 16; % window size
no_patches = size(img, 1) / ws;
X = zeros(no_patches^2, ws^2);
k = 1;
for i = (1:no_patches*2-1)
    for j = (1:no_patches*2-1)
        r1 = 1+(i-1)*ws/2:(i+1)*ws/2;
        r2 = 1+(j-1)*ws/2:(j+1)*ws/2;
        patch = img_corrupted(r1, r2);
        % str1 = strcat('Dump/Img',int2str(k),'.jpg');
        % imwrite(patch,str1);
        X(k,:) = patch(:);
        k = k + 1;
    end
end

% apply Robust PCA
lambda = 0.02; % close to the default one, but works better
tic
[W,sigma_square,Xn,t_mean,M] = em_ppca(X,q,itr);
toc

L = W*inv(W'*W)*M*Xn;
L = L + (t_mean)*ones(1,size(X,2));

% reconstruct the image from the overlapping patches in matrix L
img_reconstructed = zeros(size(img));
img_noise = zeros(size(img));
k = 1;
for i = (1:no_patches*2-1)
    for j = (1:no_patches*2-1)
        % average patches to get the image back from L and S
        % todo: in the borders less than 4 patches are averaged
        patch = reshape(L(k,:), ws, ws);
        r1 = 1+(i-1)*ws/2:(i+1)*ws/2;
        r2 = 1+(j-1)*ws/2:(j+1)*ws/2;
        img_reconstructed(r1, r2) = img_reconstructed(r1, r2) + 0.25*patch;
        k = k + 1;
    end
end
img_final = img_reconstructed;
img_final(~isnan(img_corrupted)) = img_corrupted(~isnan(img_corrupted));

% show the results
figure;
subplot(2,2,1), imshow(img_corrupted), title('Corrupted image');
str1 = strcat('Dump/Corrupted image','.jpg');
imwrite(img_corrupted,str1);

subplot(2,2,2), imshow(img_final), title('Recovered image');
str1 = strcat('Dump/Recovered image','.jpg');
imwrite(img_final,str1);

subplot(2,2,3), imshow(img_reconstructed), title('Recovered low-rank');

error = img - img_final;
RMS_error = sqrt(sum(sum(error.^2))/(size(X,1)*size(X,2)));

fprintf(1, 'rank(L)=%d\terr=%f\n', rank(L), RMS_error);