%% Align Two Point Clouds
% Expects the csv camera pose file
% And returns the ii'th rotation and transformation matrix
function alignedPointCloud = alignPointCloudToReference(refPointCloud, refAffineMatrix, curPointCloud, curAffineMatrix, ...
    refXYZRGB, curXYZRGB)
  disp(refAffineMatrix);
  disp(curAffineMatrix);
  %alignedPointCloud = curPointCloud;
  % disp(poseCsv);
  %A = [cos(pi/6) sin(pi/6) 0 0; ...
  %    -sin(pi/6) cos(pi/6) 0 0; ...
  %          0         0  1 0; ...
  %          5         5 10 1];
  %tform1 = affine3d(A);
  
  % Do this with matrix multiplications because matlab throws "not a valid
  % rigid transformation error in pctransform"
  
  %refXYZ = refXYZRGB(:,:,1:3);
  %refXYZColors = refXYZRGB(:,:,4:6);
    
  curXYZ = curXYZRGB(:,:,1:3);
  curXYZColors = curXYZRGB(:,:,4:6);
  
  if isequal(refAffineMatrix, curAffineMatrix)
      % The case of the reference frame
      alignMatrix = refAffineMatrix;
  else
      % Check if translation in alignMatrix is related to the small rotations
      % in the curAffineMatrix => Yes
      %curAffineMatrix(1,1) = 1;
      %curAffineMatrix(1,2) = 0;
      %curAffineMatrix(1,3) = 0;
      %curAffineMatrix(2,1) = 0;
      %curAffineMatrix(2,2) = 1;
      %curAffineMatrix(2,3) = 0;
      %curAffineMatrix(3,1) = 0;
      %curAffineMatrix(3,2) = 0;
      %curAffineMatrix(3,3) = 1;

      %alignMatrix = refAffineMatrix * (curAffineMatrix ^ (-1));
      alignMatrix = curAffineMatrix ^ (-1) * refAffineMatrix; % The correct one
      %alignMatrix = refAffineMatrix ^ (-1) * curAffineMatrix;
      %alignMatrix = curAffineMatrix;

      %alignMatrix = curAffineMatrix * (refAffineMatrix ^ (-1));
      % Fix the last column to be zeros everywhere and one at the end
      alignMatrix(1,4) = 0;
      alignMatrix(2,4) = 0;
      alignMatrix(3,4) = 0;
      alignMatrix(4,4) = 1;
  end
  
  iScaleFactor = 1;
  % Scale the translation 
  alignMatrix(4,1) = alignMatrix(4,1) * iScaleFactor;
  alignMatrix(4,2) = alignMatrix(4,2) * iScaleFactor;
  alignMatrix(4,3) = alignMatrix(4,3) * iScaleFactor;  
  
  disp(alignMatrix);
  
  % Add one to convert x y z to homogeneous coordinates
  A = ones(size(curXYZ, 1), size(curXYZ,2));
  curXYZ_H = cat(3, curXYZ, A);
  
  for ii = 1:size(curXYZ_H, 1)
      for jj = 1:size(curXYZ_H, 2)
          adj = squeeze(curXYZ_H(ii, jj, :));
          curXYZ_H(ii, jj, :) = adj' * alignMatrix;
          % C(:, :, i) = B(i) * A(:, :, i);
      end
  end
  
  % alignRefXYZ = curXYZ_H(:,:).' * alignMatrix;
  alignRefXYZ = curXYZ_H;
  
  alignRefEucXYZ = zeros(size(curXYZ_H, 1), size(curXYZ_H, 1), 3);
  
  % Homogeneous to euclidean coordinates
  for ii = 1:size(alignRefXYZ, 1)
      for jj = 1:size(alignRefXYZ, 2)
          adj = squeeze(alignRefXYZ(ii, jj, :));
          adj2 = [adj(1)/adj(4) adj(2)/adj(4) adj(3)/adj(4)];
          alignRefEucXYZ(ii, jj, :) = adj2;
          % C(:, :, i) = B(i) * A(:, :, i);
      end
  end
  
  %alignedPointCloudColor = pointCloud(alignRefEucXYZ, 'Color', curXYZColors);
  %alignedPointCloudColor = alignRefEucXYZ;
  alignedPointCloud = pointCloud(alignRefEucXYZ, 'Color', curXYZColors);
  
  return;
  
  %C = A * B'
  
  %alignMatrix = refAffineMatrix * curAffineMatrix';
  %alignMatrix = refAffineMatrix * inv(curAffineMatrix);
  alignMatrix = refAffineMatrix * (curAffineMatrix ^ (-1));
  %alignMatrix = refAffineMatrix/curAffineMatrix;
  
  % Fix the last column to be zeros everywhere and one at the end
  alignMatrix(1,4) = 0;
  alignMatrix(2,4) = 0;
  alignMatrix(3,4) = 0;
  alignMatrix(4,4) = 1;
  
  disp(alignMatrix); 
  
  % Verify Rotation R * R^-1 = I
  
  
  
  tformAlign = affine3d(alignMatrix);
  alignedPointCloud = pctransform(curPointCloud,tformAlign);
  
end
