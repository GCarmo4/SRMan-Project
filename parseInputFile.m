function inputData = parseInputFile(filename)
    % Initialize variables
    rollerPositions = [];
    rollerRadius = [];
    wrapDirections = {};
    
    % Open the file
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end
    
    % Read the file line by line
    while ~feof(fid)
        line = fgetl(fid);
        if startsWith(line, '%')
            % Comment line, skip it
            continue;
        elseif contains(line, 'p_i')
            % Initial point
            parts = split(line, ':');
            p_i = sscanf(parts{2}, '%f, %f').';
        elseif contains(line, 'p_f')
            % Final point
            parts = split(line, ':');
            p_f = sscanf(parts{2}, '%f, %f').';
        elseif contains(line, 'r_t')
            % Minimum clearance distance
            parts = split(line, ':');
            r_t = sscanf(parts{2}, '%f');
        else
            % Roller data
            parts = split(line, ',');
            if numel(parts) == 4
                x = str2double(parts{1});
                y = str2double(parts{2});
                radius = str2double(parts{3});
                direction = strtrim(parts{4});
                
                rollerPositions = [rollerPositions; x, y];
                rollerRadius = [rollerRadius; radius];
                wrapDirections{end+1} = direction;
            end
        end
    end
    
    % Close the file
    fclose(fid);
    
    % Store data in a structured array
    inputData.p_i = p_i;
    inputData.p_f = p_f;
    inputData.r_t = r_t;
    inputData.rollerPositions = rollerPositions;
    inputData.rollerRadius = rollerRadius;
    inputData.wrapDirections = wrapDirections;
end
