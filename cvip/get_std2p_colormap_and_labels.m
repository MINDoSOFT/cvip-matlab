function [ colormap, labels ] = get_std2p_colormap_and_labels( )
%GET_STD2P_COLORMAP_AND_LABELS Summary of this function goes here
%   Detailed explanation goes here

% OLD this is wrong because it is BGR color order
% colormap = [128 128 128; 255 0 0; 0 255 0; 0 0 255; 255 255 0;
%         255 0 255; 0 255 255; 64 255 0; 128 128 0; 128 0 128;
%         0 128 128; 64 0 192; 0 64 96; 192 64 0; 192 0 64;
%         0 192 64; 0 64 192; 128 0 255; 128 255 0; 255 128 0;
%         255 0 128; 0 128 255; 0 255 128; 32 32 192; 32 192 32;
%         192 32 32; 32 64 128; 32 128 64; 64 32 128; 64 100 16;
%         128 64 32; 128 32 64; 16 72 200; 72 16 200; 200 72 16;
%         72 200 16; 200 16 72; 72 150 100; 50 100 200;60 96 96;
%         96 96 60];
    
colormap = [128 128 128; 0 0 255; 0 255 0; 255 0 0; 0 255 255;
        255 0 255; 255 255 0; 0 255 64; 0 128 128; 128 0 128;
        128 128 0; 192 0 64; 96 64 0; 0 64 192; 64 0 192;
        64 192 0; 192 64 0; 255 0 128; 0 255 128; 0 128 255;
        128 0 255; 255 128 0; 128 255 0; 192 32 32; 32 192 32;
        32 32 192; 128 64 32; 64 128 32; 128 32 64; 16 100 64;
        32 64 128; 64 32 128; 200 72 16; 200 16 72; 16 72 200;
        16 200 72; 72 16 200; 100 150 72; 200 100 50;96 96 60];
    
labels = {'wall', 'floor', 'cabinet', 'bed', 'chair', 'sofa', 'table', 'door', 'window', 'bookshelf', 'picture', 'counter', 'blinds', 'desk', 'shelves', 'curtain', 'dresser', 'pillow', 'mirror', 'floormat', ...
        'clothes', 'ceiling', 'books', 'fridge', 'tv', 'paper', 'towel', 'showercurtain', 'box', 'whiteboard', 'person', 'nightstand', 'toilet', 'sink', 'lamp', 'bathtub', 'bag', 'otherstruct', 'otherfurntr', 'otherprop'};

end

