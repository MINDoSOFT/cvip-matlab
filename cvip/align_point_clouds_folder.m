% For input point clouds folder
% call the align_point_clouds_for_folder
% adjusting inputDir, inputDir2, outputDir, frame

bJustConvertToPLY = true; % Enable this flag to convert from PCD to PLY files

addpath(['..' filesep '..' filesep 'matpcl']);

%sceneName = 'kinectsession5_no_rotation_1';
%sceneName = 'kinectv1_0004';
sceneName = 'home_office_0001';

dataDir = ['..' filesep 'data'];
inputDir = [dataDir filesep 'inputPC' filesep sceneName filesep 'pc'];
inputDir2 = [dataDir filesep 'inputPC' filesep sceneName filesep 'pose'];
outputDir = [dataDir filesep 'outputPC' filesep sceneName];
outputDir2 = [dataDir filesep 'inputPLY' filesep sceneName];

exists_or_mkdir(outputDir);
exists_or_mkdir(outputDir2);

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
figure;
cameratoolbar;
hold on;
for ii = 1 : numel(pointClouds)  
    if bJustConvertToPLY
        % Read the pcd files
        pointCloudName = pointClouds(ii);
        inPointCloudFilepath = strjoin([inputDir filesep pointCloudName], '');
        inPointCloud = loadpcd_v2(inPointCloudFilepath);
        % Make them a MATLAB point cloud
        xyz = inPointCloud(:,:,1:3);
        xyzColors = inPointCloud(:,:,4:6);
        inPointCloudColor = pointCloud(xyz, 'Color', xyzColors);
        % Adjust the normals
        inPointCloudColor = setNormalsOfPointCloud(inPointCloudColor);
        % Store the result as PLY file
        [filepath,name,ext] = fileparts(inPointCloudFilepath);
        outPointCloudFilepath = strjoin([outputDir2 filesep cellstr(strcat(name, '.ply'))], '');
        pcwrite(inPointCloudColor, outPointCloudFilepath);
        continue
    end
%for ii = 1 : 1
  if (ii == 1)
    refRotationAndTransformation = get_camera_pose_rotation_and_transformation(cameraPoseCSV, ii);
    refPointCloudName = pointClouds(ii);
    % refPointCloud = pcread(strjoin([inputDir filesep refPointCloudName], ''));
    refPointCloud = loadpcd_v2(strjoin([inputDir filesep refPointCloudName], ''));
    xyz = refPointCloud(:,:,1:3);
    xyzColors = refPointCloud(:,:,4:6);
    refPointCloudColor = pointCloud(xyz, 'Color', xyzColors);
    %pcshow(refPointCloudColor);
    xyz2 = reshape(xyz, size(xyz, 1) * size(xyz, 2), 3);
    %scatter3(xyz2);
    %scatter3(xyz2(:,1),xyz2(:,2),xyz2(:,3), 'CData', adjImgResult, 'UserData', adjNyud2_40_classes);
    scatter3(xyz2(:,1),xyz2(:,2),xyz2(:,3),'b','.');
    %figure;
  else
      if ii == 10
    rotationAndTransformation = get_camera_pose_rotation_and_transformation(cameraPoseCSV, ii);
    curPointCloudName = pointClouds(ii);
    % curPointCloud = pcread(strjoin([inputDir filesep curPointCloudName], ''));
    curPointCloud = loadpcd_v2(strjoin([inputDir filesep curPointCloudName], ''));
    xyz = curPointCloud(:,:,1:3);
    xyzColors = curPointCloud(:,:,4:6);
    curPointCloudColor = pointCloud(xyz, 'Color', xyzColors);
    alignedPointCloudColor = alignPointCloudToReferenceV2(refPointCloudColor, ...
        refRotationAndTransformation, curPointCloudColor, rotationAndTransformation, ...
        refPointCloud, curPointCloud);
    %%%xyz2 = alignedPointCloudColor.Location;
    xyz = alignedPointCloudColor(:,:,1:3);
    %xyzColors = alignedPointCloudColor(:,:,4:6);
    %pcshow(alignedPointCloudColor);
    xyz2 = reshape(xyz, size(xyz, 1) * size(xyz, 2), 3);
    scatter3(xyz2(:,1),xyz2(:,2),xyz2(:,3),'g','.');
    %if ~(ii == numel(pointClouds))
    %  figure;
    %end
    hd = HausdorffDist(refPointCloud(:,:,1:3), xyz);
      end
  end
end

hold off;

%close all; 