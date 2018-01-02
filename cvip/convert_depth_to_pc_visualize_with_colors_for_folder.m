% Depth Intrinsic Parameters - From nyud2 toolbox
fx_d = 5.8262448167737955e+02;
fy_d = 5.8269103270988637e+02;
cx_d = 3.1304475870804731e+02;
cy_d = 2.3844389626620386e+02;

K = [fx_d 0 cx_d; 0 fy_d cy_d; 0 0 1];

saveFigures = true; % Enable to save the figures in outputDir
%inputDir = ['..' filesep 'data' filesep 'input' filesep];
%inputDir2 = ['..' filesep 'data' filesep 'input2' filesep];
%outputDir = ['..' filesep 'data' filesep 'output' filesep];

%frame = 2080; % 151 for home_office_0001, 2080 for dining_room_0036
frameStr = sprintf('%05d', frame);
frameStr2 = sprintf('%04d', frame);

imgDepth = imread([inputDir filesep frameStr '_depth_filled.png']);
imgRgb = imread([inputDir filesep frameStr '_color.png']);
imgResult = imread([inputDir2 filesep 'result' frameStr2 '.png']);
nyud2_40_classes = getfield(load([inputDir2 filesep 'score' frameStr2 '.mat'], 'pixelClasses'), 'pixelClasses');

result2DWithLegendPng = [outputDir filesep frameStr '_result2D_with_legend.png'];
result2DWithLegendFig = [outputDir filesep frameStr '_result2D_with_legend.fig']
result3DPCShowWithLegendFig = [outputDir filesep frameStr '_result3DPCShow_with_legend.fig']
result3DScatter3WithLegendFig = [outputDir filesep frameStr '_result3DScatter3_with_legend.fig']
result2DWithLegendOverlayPng = [outputDir filesep frameStr '_result2D_with_legend_overlay.png'];

figure;
imshow(imgRgb);
title('RGB image');

figure;
xyz = to3d_preserve_size(double(imgDepth), K);
pcshow(xyz);
title('Projected depth');

figure;
pcshow(xyz, imgRgb);
title('Projected depth with image colors');
cameratoolbar;

figure;

[cmap, lbl] = get_std2p_colormap_and_labels();
cmap = cmap / 256; % Colormap can use only doubles as input

xyz2 = to3d(double(imgDepth), K);
%mypcshow(xyz, imgResult);
%scatter3(x,y,z, 'CData', imgResult, 'UserData',
%scatter3(xyz2(:,1),xyz2(:,2),xyz2(:,3));

% Row-wise reshaping

%The general way to reshape an m*n matrix A to a p*k matrix B in a row-wise manner is:

%c=reshape(A',1,m*n) 
%B=reshape(c,k,p)' 
%example: m=3 n=4 , p=6, q=2

tempR = imgResult(:,:,1); 
tempG = imgResult(:,:,2);
tempB = imgResult(:,:,3);

temp = reshape(tempR', 1, size(imgResult, 1) * size(imgResult, 2));
adjTempR = reshape(temp, [size(imgResult, 1) * size(imgResult, 2), 1])';
temp = reshape(tempG', 1, size(imgResult, 1) * size(imgResult, 2));
adjTempG = reshape(temp, [size(imgResult, 1) * size(imgResult, 2), 1])';
temp = reshape(tempB', 1, size(imgResult, 1) * size(imgResult, 2));
adjTempB = reshape(temp, [size(imgResult, 1) * size(imgResult, 2), 1])';

adjImgResult = uint8(zeros(size(imgResult, 1) * size(imgResult, 2), size(imgResult, 3)));
adjImgResult(:,1) = adjTempR;
adjImgResult(:,2) = adjTempG;
adjImgResult(:,3) = adjTempB;

unqAdjResult = unique(double(adjImgResult) / 256, 'rows');

temp = reshape(nyud2_40_classes', 1, size(imgResult, 1) * size(imgResult, 2));
adjNyud2_40_classes = reshape(temp, [size(imgResult, 1) * size(imgResult, 2), 1]);

scatter3(xyz2(:,1),xyz2(:,2),xyz2(:,3), 'CData', adjImgResult, 'UserData', adjNyud2_40_classes);

% Add only the colors that exist in the current STD2P result
curColor = 1;
adjCmap = zeros(size(unqAdjResult, 1), 3);
adjLbl = cell(size(unqAdjResult, 1), 1);
for ii = 1:size(cmap,1)
    if (ismember(cmap(ii,:), unqAdjResult(:,:), 'rows')) 
      adjCmap(curColor,:) = cmap(ii,:);
      adjLbl{curColor} = lbl{ii};
      curColor = curColor + 1;
    end
end

colormap(adjCmap);

clearvars('p'); % To prevent problems with multiple launches of script
% Add only the colors that exist in the current STD2P result
for ii = 1:size(adjCmap,1)
    p(ii) = patch(NaN, NaN, adjCmap(ii,:));
end

legend(p, adjLbl);
title('Projected depth with STD2P output');
cameratoolbar;

if (saveFigures) 
   saveas(gcf, result3DScatter3WithLegendFig);
end

figure;
pcshow(xyz, imgResult); %This was before adding the legend
colormap(adjCmap);

% Add only the colors that exist in the current STD2P result
for ii = 1:size(adjCmap,1)
    p(ii) = patch(NaN, NaN, adjCmap(ii,:));
end

legend(p, adjLbl);
title('Projected depth with STD2P output');

if (saveFigures) 
   saveas(gcf, result3DPCShowWithLegendFig);
end

figure;
imshow(imgResult);
colormap(adjCmap);

% Add only the colors that exist in the current STD2P result
for ii = 1:size(adjCmap,1)
    p(ii) = patch(NaN, NaN, adjCmap(ii,:));
end

legend(p, adjLbl);
title('STD2P Result image');

if (saveFigures) 
   saveas(gcf, result2DWithLegendPng);
   saveas(gcf, result2DWithLegendFig);
end

figure;
imshow(imgRgb);
hold on;
h = imagesc( imgResult ); % show the edge image
set( h, 'AlphaData', .5 ); % .5 transparency
hold off;
colormap(adjCmap);

% Add only the colors that exist in the current STD2P result
for ii = 1:size(adjCmap,1)
    p(ii) = patch(NaN, NaN, adjCmap(ii,:));
end

legend(p, adjLbl);
title('STD2P Result image');

if (saveFigures) 
   saveas(gcf, result2DWithLegendOverlayPng);
end

