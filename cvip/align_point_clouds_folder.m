% For input point clouds folder
% call the align_point_clouds_for_folder
% adjusting inputDir, inputDir2, outputDir, frame

addpath(['..' filesep '..' filesep 'matpcl']);

sceneName = 'kinectv1_0004';
%sceneName = 'home_office_0001';

dataDir = ['..' filesep 'data'];
inputDir = [dataDir filesep 'inputPC' filesep sceneName filesep 'pc'];
inputDir2 = [dataDir filesep 'inputPC' filesep sceneName filesep 'pose'];
outputDir = [dataDir filesep 'outputPC' filesep sceneName];

exists_or_mkdir(outputDir);

pointClouds = dir([inputDir filesep '*.pcd']);
xlsfiles={pointClouds.name};
pointClouds=sort(xlsfiles);

cameraPoses = dir([inputDir2 filesep '*.csv']);
xlsfiles2={cameraPoses.name};
cameraPoses=sort(xlsfiles2);

format long;
% This should be 1
cameraPoseName = cameraPoses(1);
cameraPoseName = strjoin([inputDir2 filesep cameraPoseName], '');
% csvread rounds so it is not useful
% cameraPoseCSV = csvread(strjoin([inputDir2 filesep cameraPoseName], ''));
% cameraPoseCSV = importCameraPoseFile(strjoin([inputDir2 filesep cameraPoseName], ''));
%cameraPoseCSV = dlmread(strjoin([inputDir2 filesep cameraPoseName], ''), ',');
% Get rid of the last column
%cameraPoseCSV = cameraPoseCSV(:, 1:4);

delimiterIn = ' ';
headerlinesIn = 0;
cameraPoseCSV = importdata(cameraPoseName,delimiterIn,headerlinesIn);

% rotationAndTransformation = get_camera_pose_rotation_and_transformation(cameraPoseCSV, 0);

% For each point cloud pair *.pcd file in inputDir
% using first frame as the reference point cloud
% and camera pose for each frame
% generate the aligned point clouds
for ii = 1 : numel(pointClouds)  
  if (ii == 1)
    refRotationAndTransformation = get_camera_pose_rotation_and_transformation(cameraPoseCSV, ii);
    refPointCloudName = pointClouds(ii);
    % refPointCloud = pcread(strjoin([inputDir filesep refPointCloudName], ''));
    refPointCloud = loadpcd_v2(strjoin([inputDir filesep refPointCloudName], ''));
    xyz = refPointCloud(:,:,1:3);
    xyzColors = refPointCloud(:,:,4:6);
    refPointCloudColor = pointCloud(xyz, 'Color', xyzColors);
    pcshow(refPointCloudColor);
    figure;
  else
    rotationAndTransformation = get_camera_pose_rotation_and_transformation(cameraPoseCSV, ii);
    curPointCloudName = pointClouds(ii);
    % curPointCloud = pcread(strjoin([inputDir filesep curPointCloudName], ''));
    curPointCloud = loadpcd_v2(strjoin([inputDir filesep curPointCloudName], ''));
    xyz = curPointCloud(:,:,1:3);
    xyzColors = curPointCloud(:,:,4:6);
    curPointCloudColor = pointCloud(xyz, 'Color', xyzColors);
    alignedPointCloudColor = alignPointCloudToReference(refPointCloudColor, ...
        refRotationAndTransformation, curPointCloudColor, rotationAndTransformation);
    pcshow(alignedPointCloudColor);
    if ~(ii == numel(pointClouds))
      figure;
    end
  end
end

%close all; 