function frameNumber = getFrameNumberFromFilename(filename)
  numericMatches = regexp(filename, '\d*','Match');
  % Return numeric match (will convert 0001 to 1)
  frameNumber = str2num(char(numericMatches));
  % This would be required if multiple numbers were in the filename
  % frameNumber = str2num(numericMatches{end}{end});
end
