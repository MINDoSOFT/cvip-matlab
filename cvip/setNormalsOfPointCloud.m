%% Set normals of a point cloud so that ICP works
function pointCloudWithNormals = setNormalsOfPointCloud(inPointCloud)

    normals = pcnormals(inPointCloud);

    % Retrieve some of the points
    %x = curPointCloud.Location(1:10:end,1:10:end,1);
    %y = curPointCloud.Location(1:10:end,1:10:end,2);
    %z = curPointCloud.Location(1:10:end,1:10:end,3);
    %u = normals(1:10:end,1:10:end,1);
    %v = normals(1:10:end,1:10:end,2);
    %w = normals(1:10:end,1:10:end,3);
    
    % Retrieve all the points
    if length(size(inPointCloud.Location)) == 3
        % When used from alignPointCloudToReference function
        x = inPointCloud.Location(:,:,1);
        y = inPointCloud.Location(:,:,2);
        z = inPointCloud.Location(:,:,3);
        u = normals(:,:,1);
        v = normals(:,:,2);
        w = normals(:,:,3);
    elseif length(size(inPointCloud.Location)) == 2
        % When used from convert_depth_to_pc_visualize_with_colors_for_folder function
        x = inPointCloud.Location(:,1);
        y = inPointCloud.Location(:,2);
        z = inPointCloud.Location(:,3);
        u = normals(:,1);
        v = normals(:,2);
        w = normals(:,3);
    else
        disp('Cannot handle this point cloud case.');
        return;
    end

    sensorCenter = [0,-0.3,0.3]; 
    for k = 1 : numel(x)
       p1 = sensorCenter - [x(k),y(k),z(k)];
       p2 = [u(k),v(k),w(k)];
       % Flip the normal vector if it is not pointing towards the sensor.
       angle = atan2(norm(cross(p1,p2)),p1*p2');
       if angle > pi/2 || angle < -pi/2
           u(k) = -u(k);
           v(k) = -v(k);
           w(k) = -w(k);
       end
    end
    
    uv = cat(3, u, v);
    uvw = cat(3, uv, w);
    
    if length(size(uvw)) == 3
        uvw = squeeze(uvw);
    elseif length(size(uvw)) == 2
        disp('This case is OK');
    else
        disp('Cannot handle this uvw case.');
        return;
    end
    
    inPointCloud.Normal = uvw;
    
    pointCloudWithNormals = inPointCloud;
end
