function [ adjDepth ] = discardNoiseFromDepth( depth, depthNoise )
  % Set where depthNoise is <> 0, depth to NaN
  adjDepth = depth;
  adjDepth(depthNoise ~= 0) = NaN;
end
