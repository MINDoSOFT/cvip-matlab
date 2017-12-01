% Depth Intrinsic Parameters - From nyud2 toolbox
fx_d = 5.8262448167737955e+02;
fy_d = 5.8269103270988637e+02;
cx_d = 3.1304475870804731e+02;
cy_d = 2.3844389626620386e+02;

K = [fx_d 0 cx_d; 0 fy_d cy_d; 0 0 1];

%imgDepth = imread('../data/01930_depth_filled.png');
%imgRgb = imread('../data/01930_color.png');
%imgRawDepth = imread('../data/01930_raw_depth.png');

imgDepth = imread('../data/00151_depth_filled.png');
imgRgb = imread('../data/00151_color.png');
imgRawDepth = imread('../data/00151_raw_depth.png');
imgResult = imread('../data/00151_result.png');

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
pcshow(xyz, imgResult);
title('Projected depth with STD2P output');
cameratoolbar;