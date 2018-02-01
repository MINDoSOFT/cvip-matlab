%% Align Two Point Clouds
% Expects the csv camera pose file
% And returns the ii'th rotation and transformation matrix
function alignedPointCloud = alignPointCloudToReferenceV2(refPointCloud, refAffineMatrix, curPointCloud, curAffineMatrix, ...
    refXYZRGB, curXYZRGB)

    % Will not use the affine matrixes, we'll go with the MATLAB way

    % Reference: https://www.mathworks.com/help/vision/examples/3-d-point-cloud-registration-and-stitching.html

    gridSize = 0.1;
    
    % Adjust the normals 
    % Reference: https://www.mathworks.com/help/vision/ref/pcregrigid.html
    % "Point cloud normals are required by the registration algorithm when
    % you select the 'pointToPlane' metric."
    %refPointCloud = setNormalsOfPointCloud(refPointCloud);
    %curPointCloud = setNormalsOfPointCloud(curPointCloud);
    
    fixed = pcdownsample(refPointCloud, 'gridAverage', gridSize);
    moving = pcdownsample(curPointCloud, 'gridAverage', gridSize);

    % Apply ICP registration.
    tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);

    % Transform the current point cloud to the reference coordinate system
    % defined by the first point cloud.
    alignedPointCloud = pctransform(curPointCloud, tform);
  
end
