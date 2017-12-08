clear;close all;clc;

%% Unknown Image Cleanup and Extraction
Image = imread('unknown.jpg');
Imagemed = medfilt2(Image, [100 100]);
Imagefinal = Imagemed - Image;
BWImage = Imagefinal > 5;


BW2 = BWImage;

[labels, number] = bwlabel(BW2, 8);
Istats = regionprops(labels, 'basic', 'Centroid');


[values, index] = sort([Istats.Area], 'descend');
[maxVal, maxIndex] = max([Istats.Area]);

Istats([Istats.Area] < 1000) = [];
numImage = length(Istats);

Ibox = floor([Istats.BoundingBox]);
Ibox = reshape(Ibox, [4 numImage]);


for k = 1:numImage
    col1 = Ibox(1, k);
    col2 = Ibox(1, k)+ Ibox(3, k);
    row1 = Ibox(2, k);
    row2 = Ibox(2, k) + Ibox(4,k);
    subImage = BW2(row1:row2, col1:col2);
    UnknownImage{k} = subImage;
    UnknownImageScaled{k} = imresize(subImage, [24 12]);
end
%% Template Image Cleanup and Extraction
Template = imread('template.jpg');
Templatemed = medfilt2(Template, [100 100]);
Templatefinal = Templatemed - Template;
BWTemplate = Templatefinal > 5;




[labelsTemplate, numberTemplate] = bwlabel(BWTemplate, 8);
IstatsTemplate = regionprops(labelsTemplate, 'basic', 'Centroid');


[values, index] = sort([IstatsTemplate.Area], 'descend');
[maxVal, maxIndex] = max([IstatsTemplate.Area]);

IstatsTemplate([IstatsTemplate.Area] < 1000) = []; %reject dots
numTemplate = length(IstatsTemplate);

IboxTemplate = floor([IstatsTemplate.BoundingBox]);
IboxTemplate = reshape(IboxTemplate, [4 numTemplate]);



for k = 1:numTemplate
    col1 = IboxTemplate(1, k);
    col2 = IboxTemplate(1, k)+ IboxTemplate(3, k);
    row1 = IboxTemplate(2, k);
    row2 = IboxTemplate(2, k) + IboxTemplate(4,k);
    subImage = BWTemplate(row1:row2, col1:col2);
    TemplateImage{k} = subImage;
    TemplateImageScaled{k} = imresize(subImage, [24 12]);
end

%% Cross Correlation
for k = 1:numImage
    for b = 1:numTemplate
        corr(b,k) = max(max(normxcorr2(UnknownImageScaled{k}, TemplateImageScaled{b})));
%         
    end
end
[values, index] = max(corr(:,:));
index-1


