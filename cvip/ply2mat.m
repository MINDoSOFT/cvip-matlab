function [ P, C ] = ply2mat( filePath )
% [ P, C ] = PLY2MAP( filePath )
%
% Converts '.ply' format file to 3D point cloud (x,y,z).
%
% INPUT
%
% filePath: Path to the '.ply' file store
%
% OUTPUT
%
% P: 3D array of point cloud coordinates x,y,z (N x 3).
%
% C: 3D array of RGB values for each point (N x 3).

% Giulio Marin
%
% giulio.marin@me.com
% 2014/11/07

%% Script

% Open file
fid = fopen(filePath,'r');

% Get number of points
found = false;
currLine = '';
while ~found
    currLine = fgetl(fid);
    found = ~isempty(strfind(currLine,'element vertex'));
end
nPoints = sscanf(currLine, 'element vertex %d\n');

found = false;
totalLine = '';
while ~found
    currLine = fgetl(fid);
    totalLine = [totalLine currLine];
    found = ~isempty(strfind(currLine,'end_header'));
end

% Allocate output matrices
P = zeros(nPoints,3);
C = zeros(nPoints,3);

% Check if color and alpha are present
noColor = isempty([strfind(totalLine,'red') strfind(totalLine,'blue') strfind(totalLine,'green')]);
noAlpha = isempty(strfind(totalLine,'alpha'));

% Fill output matrices. Color and alpha may not be present
if noColor
    for i=1:nPoints
        [values,~] = fscanf(fid, '%f %f %f\n',3);
        P(i,1:3) = values(1:3,1);
    end
elseif noAlpha
    for i=1:nPoints
        [values,~] = fscanf(fid, '%f %f %f %d %d %d\n',6);
        P(i,1:3) = values(1:3,1);
        C(i,1:3) = values(4:6,1);
    end
else
    for i=1:nPoints
        [values,~] = fscanf(fid, '%f %f %f %d %d %d %d\n',7);
        P(i,1:3) = values(1:3,1);
        C(i,1:3) = values(4:6,1);
    end
end

% Close file
fclose(fid);

end

