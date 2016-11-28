% function imgOut = imgRecover(imgIn, blkSize, numSample)
% Recover the input image from a small size samples
%
% INPUT:
%   imgIn: input image
%   blkSize: block size
%   numSample: how many samples in each block
%
% OUTPUT:
%   imgOut: recovered image
%
% @ 2011 Huapeng Zhou -- huapengz@andrew.cmu.edu
tic;

% image=imgRead(imgIn);
% K=blkSize;

image=imgRead('lena.bmp');
K=16;
numSample = 100;

no_blocks_row = size(image,1)/K;
no_blocks_col = size(image,2)/K;

no_row = repmat(K,[1 no_blocks_row]);%creating the row dim for mat2cell

no_col = repmat(K,[1 no_blocks_col]);%creating the col dim for mat2cell

blocks = mat2cell(image,no_row,no_col);

dummy = zeros(size(image,1),size(image,2));
ghat = mat2cell(dummy,no_row,no_col);

blocks_vec = reshape(blocks,size(blocks,1)*size(blocks,2),1);

ghat_vec = reshape(blocks,size(ghat,1)*size(ghat,2),1);

for k = 1:length(blocks_vec)
%     k
fprintf('Running for block %d \n',k)
fprintf('Remaining blocks = %d \n',length(blocks_vec)-k)
block = blocks_vec{k};
disp('Computing Transform...')
T=transform_per_block(block,K);
C=reshape(block,size(block,1)*size(block,2),1);

%%%%%%%% NUMBER OF SAMPLES  %%%%%%%%

random_numbers = randperm(size(block,1)*size(block,2),numSample);

B=C(random_numbers);
A=T(random_numbers,:);

%%%%%%%%  CROSS-VALIDATION %%%%%%%%%%

m=floor(numSample/6);
disp('Initiating Cross Validation...')

% disp('lambda for this block...')
[lambda]=crossValidation(A,B,m);


%%%%%%%%%%%%%%% OMP %%%%%%%%%%%%%%%%%%%

disp('Initiating OMP...')
[DCT] = OMP(A,B,lambda);
% D(:,k)=DCT;

%%%%%%% RECONSTRUCTING THE BLOCK %%%%%%%

ghat = T * DCT;
gghat = reshape(ghat,K,K);
ghat_vec{k} = gghat;
disp('***done***')
end

%%reshaping vector to matrix block arrangement
ghat_cell = reshape(ghat_vec,no_blocks_row,no_blocks_col);

%%converting block cells to image matrix
reconst_image = cell2mat(ghat_cell);
imgOut = reconst_image;
figure;imgShow(reconst_image);
title('Reconstructed Image without Median filtering');

%%% MEDIAN FILTERING %%%%
fil_image=medfilt2(reconst_image,[3 3]);

figure;imgShow(fil_image);
a=['After median filtering of 3x3 and Sample size of ' num2str(numSample)]
title(a);

%%%%%% ERROR COMPUTATION %%%%%%%%%%%%%
recovery_error = mean(mean((reconst_image-image).^2))
recovery_error_filtered = mean(mean((fil_image-image).^2))
toc;
% end