% Expects the csv camera pose file
% And returns the ii'th rotation and transformation matrix
function rotationAndTransformation = get_camera_pose_rotation_and_transformation(poseCsv, ii)
  % disp(poseCsv);
  %A = [cos(pi/6) sin(pi/6) 0 0; ...
  %    -sin(pi/6) cos(pi/6) 0 0; ...
  %          0         0  1 0; ...
  %          5         5 10 1];
  %tform1 = affine3d(A);
  
  skipRows = (ii-1) * 4; % -1 for MATLAB style index
  
  rotationAndTransformation = [poseCsv(skipRows + 1:skipRows + 4, 1:4)];
end
