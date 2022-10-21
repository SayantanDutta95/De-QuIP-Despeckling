% Sample code of the papers:
% 
% Sayantan Dutta, Adrian Basarab, Bertrand Georgeot, and Denis Kouamé,
% "A Novel Image Denoising Algorithm Using Concepts of Quantum Many-Body Theory,"
% arXiv preprint arXiv(2021).
%
% Sayantan Dutta, Adrian Basarab, Bertrand Georgeot, and Denis Kouamé,
% "Image Denoising Inspired by Quantum Many-Body physics,"
% 2021 IEEE International Conference on Image Processing (ICIP), 2021,
% pp. 1619-1623, doi: 10.1109/ICIP42928.2021.9506794.
%
% Sayantan Dutta, Adrian Basarab, Bertrand Georgeot, and Denis Kouamé,
% "Quantum mechanics-based signal and image representation: Application
% to denoising," IEEE Open Journal of Signal Processing, vol. 2, pp. 190–206, 2021.
% 
% Sayantan Dutta, Adrian Basarab, Bertrand Georgeot, and Denis Kouamé,
% "Despeckling Ultrasound Images Using Quantum Many-Body Physics,"
% 2021 IEEE International Ultrasonics Symposium (IUS), 2021, pp. 1-4,
% doi: 10.1109/IUS52206.2021.9593778.
%
% One should cite all these papers for using the code.
%---------------------------------------------------------------------------------------------------
% MATLAB code prepard by Sayantan Dutta
% E-mail: sayantan.dutta@irit.fr and sayantan.dutta110@gmail.com
% 
% This script shows an example of our image denoising algorithm 
% Denoising by Quantum Interactive Patches (De-QuIP)
%---------------------------------------------------------------------------------------------------


close all
clear all
clc

% load data
ima = ReadImage('data\CDs_Andrej\Thyroid_data\THYR_1_001.dat');

% plot input image
figure, imagesc(ima,[min(ima(:)) max(ima(:))]); colormap gray

% Choose parameters
WP=7;              % patch size
hW=10;              % half window size
factor_thr= 2.5;    % thresholding factor

del = 5;
threshold =   factor_thr * del;

delta = hW;         %< 2*hW+WP; % half window size for the searching zone
p = .95;             % proportionality constant
d = 20;             % reduced dimention
fact =2.1;          % Planck constant factor

% Start denoising process
local_time=tic;
% Divide image into small patches
ima_patchs = spatial_patchization(ima, WP); % Divide noisy image

% Denoising process
ima_patchs_fil = DeQuIP_denoising(ima_patchs, hW, delta, p, d, fact, threshold, del);

% Reproject the small patches to construct the denoised image
ima_DeQuIP = reprojection_UWA(ima_patchs_fil);
local_time=toc(local_time);


% Display output
figure('Position',[100 100  800 400])
subplot(121);imagesc(ima,[min(ima(:)) max(ima(:))]); colormap gray
title('Speckled US image');
subplot(122);imagesc(ima_DeQuIP,[min(ima_DeQuIP(:)) max(ima_DeQuIP(:))]); colormap gray
title('Despeckled US image');
