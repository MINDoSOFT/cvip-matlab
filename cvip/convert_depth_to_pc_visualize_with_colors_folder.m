% For input images folder and std2p results
% call the convert_depth_to_pc_visualize_with_colors_for_folder
% adjusting inputDir, inputDir2, outputDir, frame

%sceneName = 'kinectv1_0004';
%sceneName = 'kinectsession5_no_rotation_1';
sceneName = 'dining_room_0036';

dataDir = ['..' filesep 'data'];
inputDir = [dataDir filesep 'input' filesep sceneName filesep 'input'];
inputDir2 = [dataDir filesep 'input' filesep sceneName filesep 'std2p'];
outputDir = [dataDir filesep 'output' filesep sceneName];

exists_or_mkdir(outputDir);

images = dir([inputDir filesep '*_color.png']);
xlsfiles={images.name};
images=sort(xlsfiles);

% For each image 00000_color.png file in inputDir
for ii = 1 : numel(images)
  image = images(ii);
  % Retrieve the frame number
  frame = getFrameNumberFromFilename(image{1});
  convert_depth_to_pc_visualize_with_colors_for_folder;
  close all;    
end
