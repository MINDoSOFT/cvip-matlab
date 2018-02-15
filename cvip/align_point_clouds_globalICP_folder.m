% For input point clouds folder
% call the align_point_clouds_for_folder
% adjusting inputDir, inputDir2, outputDir, frame

%close all;

bJustDisplay = false;

addpath(['..' filesep '..' filesep 'matpcl']);
addpath(genpath(['..' filesep '..' filesep 'pointCloudTools']));

%sceneName = 'dining_room_0036';
%sceneName = 'default_data'; % use xyz as input
%sceneName = 'kinectsession5_no_rotation_1';
%sceneName = 'kinectv1_0004';
%sceneName = 'kinectv1_0004_target_frames';
%sceneName = 'home_office_0001';
sceneName = 'kinectv1_0006';

dataDir = ['..' filesep 'data'];
inputDir = [dataDir filesep 'inputPLY' filesep sceneName];
outputDir = [dataDir filesep 'outputPLY' filesep sceneName];

exists_or_mkdir(outputDir);

pointClouds = dir([inputDir filesep '*.ply']);
%pointClouds = dir([inputDir filesep '*.xyz']);
xlsfiles={pointClouds.name};
pointClouds=sort(xlsfiles);

format long;

% For each point cloud pair *.pcd file in inputDir
% using first frame as the reference point cloud
% and camera pose for each frame
% generate the aligned point clouds
%figure;
%cameratoolbar;
%hold on;

% Contruct an object of class globalICP (=initialization)
icp = globalICP;

for ii = 1 : 2
%for ii = 1 : numel(pointClouds)  
    curPointCloudName = pointClouds(ii);
    pointCloudFileName = strjoin([inputDir filesep curPointCloudName], '');
    
    if bJustDisplay
        pc = pointCloud(pointCloudFileName, 'Attributes', {'red' 'green' 'blue'});

        % Plot point cloud
        pc.plot('Color', 'A.rgb', ... % rgb-colored plot
            'MarkerSize', 5); % size of points
    else
        %icp.addPC(pointCloudFileName, 'Attributes', {'red' 'green' 'blue'});
        icp.addPC(pointCloudFileName);
    end
end

if bJustDisplay
   return; 
end

% Plot all point clouds BEFORE ICP (each in a different random color)
icp.plot('Color', 'by PC');
title('BEFORE ICP', 'Color', 'w'); view(0,0); set(gcf, 'Name', 'BEFORE ICP');
drawnow; % To fix changing title of the wrong plot !!!

icp.runICP( ...
    'UniformSamplingDistance', 0.6, ...
    'NoOfTransfParam', 12 ...
);

% Run ICP!
% Works for 1 - 2, Kinectv1_0006
%icp.runICP( ...
%    'UniformSamplingDistance', 0.5, ...
%    'NoOfTransfParam', 12 ...
%);

% Run ICP!
%icp.runICP('UniformSamplingDistance', 2, ...
%           'PlaneSearchRadius', 2);
       %, 'NoOfTransfParam', 7);
       
%icp.runICP('PlaneSearchRadius', 5, ...
%           'NoOfTransfParam', 6, ...
%           'MaxDeltaAngle', 30, ...
%           'LogLevel', 'basic');

% Run ICP!
%icp.runICP( ...
%    'NormalSubsampling', true, ...
%    'SubsamplingPercentPoi', 75 ...
%);
%'NoOfTransfParam', 6, ...
%'MaxNoIt', 5, ...

%'MaxLeverageSubsampling', true, ...
%'SubsamplingPercentPoi', 30 ...

% % Plot all point clouds AFTER ICP
icp.plot('Color', 'by PC');
title('AFTER ICP', 'Color', 'w'); view(0,0); set(gcf, 'Name', 'AFTER ICP');

return;

% Save the aligned point clouds
for ii = 1 : 5
%for ii = 1 : numel(pointClouds)  
    curPointCloudName = pointClouds(ii);
    outPointCloudFileName = strjoin([outputDir filesep curPointCloudName], '');    
    icp.exportPC(ii, outPointCloudFileName);
end

%hold off;

%close all; 