sceneName = 'home_office_0001';

dataDir = ['..' filesep 'data'];
inputDirectory = [dataDir filesep 'inputPLY' filesep sceneName];
inputType = '*.ply';

pointClouds = dir([inputDirectory filesep inputType]);
xlsfiles={pointClouds.name};
pointClouds=sort(xlsfiles);

% Just compare the first two files for now

if numel(pointClouds) >= 2
   disp('Yeah')
   firstPointCloudName = pointClouds(1);
   pc1filepath = strjoin([inputDirectory filesep firstPointCloudName], '');
   pc1 = pcread(pc1filepath);
   
   secondPointCloudName = pointClouds(2);
   pc2filepath = strjoin([inputDirectory filesep secondPointCloudName], '');
   pc2 = pcread(pc2filepath);
   
   pcshowpair(pc1, pc2);
end
