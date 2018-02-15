addpath(['..' filesep '..' filesep 'matpcl']);

%sceneName = 'dining_room_0036';
%sceneName = 'default_data'; % use xyz as input
%sceneName = 'kinectsession5_no_rotation_1';
sceneName = 'kinectv1_0004';
%sceneName = 'home_office_0001';

dataDir = ['..' filesep 'data'];
inputDir = [dataDir filesep 'inputPLY' filesep sceneName];
outputDir = [dataDir filesep 'outputPLY' filesep sceneName];

exists_or_mkdir(outputDir);

pointCloudsBefore = dir([inputDir filesep '*.ply']);
%pointCloudsBefore = dir([inputDir filesep '*.xyz']);
xlsfiles={pointCloudsBefore.name};
pointCloudsBefore=sort(xlsfiles);

pointCloudsAfter = dir([outputDir filesep '*.ply']);
%pointCloudsAfter = dir([outputDir filesep '*.xyz']);
xlsfiles={pointCloudsAfter.name};
pointCloudsAfter=sort(xlsfiles);

format long;

for ii = 1 : 2
%for ii = 1 : numel(pointClouds)  
    % Generate the filenames
    pointCloud1BeforeName = pointCloudsBefore(ii);
    pointCloud1BeforeFileName = strjoin([inputDir filesep pointCloud1BeforeName], '');
    pointCloud2BeforeName = pointCloudsBefore(ii + 1);
    pointCloud2BeforeFileName = strjoin([inputDir filesep pointCloud2BeforeName], '');
    pointCloud1AfterName = pointCloudsAfter(ii);
    pointCloud1AfterFileName = strjoin([outputDir filesep pointCloud1AfterName], '');
    pointCloud2AfterName = pointCloudsAfter(ii + 1);
    pointCloud2AfterFileName = strjoin([outputDir filesep pointCloud2AfterName], '');
    
    % Retrieve the point clouds
    pointCloudBefore1 = pcread(pointCloud1BeforeFileName);
    pointCloudBefore2 = pcread(pointCloud2BeforeFileName);
    pointCloudAfter1 = pcread(pointCloud1AfterFileName);
    pointCloudAfter2 = pcread(pointCloud2AfterFileName);

    % Calculate the distance before alignment
    hdBefore = HausdorffDist(pointCloudBefore1, pointCloudBefore2);
    % Calculate the distance after alignment
    hdAfter = HausdorffDist(pointCloudAfter1, pointCloudAfter2);
end
