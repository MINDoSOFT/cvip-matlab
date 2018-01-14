%% Align Two Point Clouds
% Expects the csv camera pose file
% And returns the ii'th rotation and transformation matrix
function alignedPointCloud = alignPointCloudToReference(refPointCloud, refAffineMatrix, curPointCloud, curAffineMatrix)
  disp(refAffineMatrix);
  disp(curAffineMatrix);
  %alignedPointCloud = curPointCloud;
  % disp(poseCsv);
  %A = [cos(pi/6) sin(pi/6) 0 0; ...
  %    -sin(pi/6) cos(pi/6) 0 0; ...
  %          0         0  1 0; ...
  %          5         5 10 1];
  %tform1 = affine3d(A);
  
  %C = A * B'
  
  alignMatrix = refAffineMatrix * curAffineMatrix';
  disp(alignMatrix);
  
  tformAlign = affine3d(alignMatrix);
  alignedPointCloud = pctransform(curPointCloud,tformAlign);
  
end
