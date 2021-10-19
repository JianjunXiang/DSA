% demo.
% extract perceptual features.
clear;close;
clc;
num = 0;
addpath(genpath('fdct_usfft_matlab'));
path_dis_img = dir('./HEVC_flowers_44/*.bmp');
for c = 1:9
    for r = 1:9
        h(1,(r-1)*9+c) = (c-1)*9+r;
    end
end
%% extract the features of each SAI.
for k = 1:81
    dis_img = double(rgb2gray(imread(strcat(path_dis_img(k).folder,'\',path_dis_img(k).name))));
    dis_img = dis_img(2:end-1,2:end-1);
    SAI_feature(k,:) = feature_extract(dis_img,1);
    stock_h(:,:,k) = dis_img;
    stock_v(:,:,h(k)) = dis_img;
end
SAIS_feature = mean(SAI_feature);
%% extract the features of MDIs
for c = 1:9
    DSI_h(:,:,(c-1)*8+1:c*8) = abs(stock_h(:,:,(c-1)*9+1:(c-1)*9+8)-stock_h(:,:,(c-1)*9+2:(c-1)*9+9));
    DSI_v(:,:,(c-1)*8+1:c*8) = abs(stock_v(:,:,(c-1)*9+1:(c-1)*9+8)-stock_v(:,:,(c-1)*9+2:(c-1)*9+9));
end
MDI_h = mean(DSI_h,3);
MDI_v = mean(DSI_v,3);
MDI_h_feature = feature_extract(MDI_h,2);
MDI_v_feature = feature_extract(MDI_v,2);
[H,W,C] = size(stock_h);

%% extract the feature of EPIs
for k = 1:H
    EPI_H = squeeze(stock_h(k,:,:))';
    for c = 1:9
        EPI = EPI_H((c-1)*9+1:c*9,:);
        feature_EPI_H((k-1)*9+c,:) = zichuang(EPI);
    end
end

for k = 1:W
    EPI_W = squeeze(stock_v(:,k,:))';
    for c = 1:9
        EPI = EPI_W((c-1)*9+1:c*9,:);
        feature_EPI_W((k-1)*9+c,:) = zichuang(EPI);
    end
end
EPI_H_feature = mean(feature_EPI_H);
EPI_W_feature = mean(feature_EPI_W);

Feat = [SAIS_feature MDI_h_feature MDI_v_feature EPI_H_feature EPI_W_feature];


