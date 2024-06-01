function trajectory = computeTrajectory(p_f, rollerPositions, rollerRadius, wrapDirections, r_t)
    % Initialize the trajectory with the starting point
    trajectory = [];
    
    % Iterate through each roller
    for k = 1:length(rollerPositions)-1
        P1 = rollerPositions(k, :)';
        P2 = rollerPositions(k+1, :)';
        r1 = rollerRadius(k) + r_t; % w/ clearance radius
        r2 = rollerRadius(k+1) + r_t; % w/ clearance radius
        wrapDirection1 = wrapDirections{k};
        wrapDirection2 = wrapDirections{k+1};

        % Compute distance between rollers
        P12 = P2 - P1;
        d = norm(P12);

        % Calculate gamma based on wrapping directions
        if (strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CCW')) || ...
           (strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CW'))
            gamma = acos((r1 + r2) / d);
        elseif (strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CW')) || ...
               (strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CCW'))
            gamma = acos((r1 - r2) / d);
        else
            error('Unexpected wrapping direction combination');
        end

        % Normalize P12 to get direction
        P12_dir = P12 / d;

        % Compute tangency points
        if strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CCW')
            t_out = P1 + rotation(gamma) * P12_dir * r1;
            t_in = P2 - rotation(gamma) * P12_dir * r2;
        elseif strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CW')
            t_out = P1 + rotation(-gamma) * P12_dir * r1;
            t_in = P2 - rotation(-gamma) * P12_dir * r2;
        elseif strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CW')
            t_out = P1 + rotation(gamma) * P12_dir * r1;
            t_in = P2 + rotation(gamma) * P12_dir * r2;
        elseif strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CCW')
            t_out = P1 + rotation(-gamma) * P12_dir * r1;
            t_in = P2 + rotation(-gamma) * P12_dir * r2;
        end

        t_out = t_out';
        t_in = t_in';

        % Add debug statements
        fprintf('Roller %d -> %d\n', k, k+1);
        fprintf('Prev Position: (%.2f, %.2f), Curr Position: (%.2f, %.2f)\n', P1, P2);
        fprintf('Prev Radius: %.2f, Curr Radius: %.2f\n', r1, r2);
        fprintf('Distance: %.2f, Gamma: %.2f\n', d, gamma);
        fprintf('Tangency Point Out: (%.2f, %.2f)\n', t_out);
        fprintf('Tangency Point In: (%.2f, %.2f)\n', t_in);

        if (k == 1) 
            % Add the outcoming and incoming tangency point to the trajectory
            trajectory = [t_out; t_in];
        else
            % Generate the arc from the current position to the tangency point
            arcToTout = generateArc(currentPosition, t_out, P1, r1, wrapDirection1)';
            trajectory = [trajectory; arcToTout'];
    
            % Add the outgoing tangency point to the trajectory
            trajectory = [trajectory; t_out];

            % Add the incoming tangency point to the trajectory
            trajectory = [trajectory; t_in];
        end
        
        % Update the current position       
        currentPosition = t_in;
    end

    % Handle the last roller to get the outgoing tangency point
    P_last = rollerPositions(end, :)';
    r_last = rollerRadius(end) + r_t; % w/ clearance radius
    wrapDirection_last = wrapDirections{end};

    gamma = acos(r_last/d);

    Pcurr_pf = p_f' - P_last;
    d = norm(Pcurr_pf);
    Pcurr_pf_dir = Pcurr_pf / d;

    % Compute tangency point
    if strcmpi(wrapDirection_last, 'CW')
        t_out = P_last + rotation(gamma) * Pcurr_pf_dir * r_last;
    elseif strcmpi(wrapDirection_last, 'CCW')
        t_out = P_last + rotation(-gamma) * Pcurr_pf_dir * r_last;
    end

    fprintf('Prev Position: (%.2f, %.2f), Curr Position: (%.2f, %.2f)\n', P1, P2);
    fprintf('Prev Radius: %.2f, Curr Radius: %.2f\n', r1, r2);
    fprintf('Distance: %.2f, Gamma: %.2f\n', d, gamma);
    fprintf('Tangency Point Out: (%.2f, %.2f)\n', t_out);

    % Generate the arc from the current position to the tangency point
    arcToTout = generateArc(currentPosition, t_out, P_last, r_last, wrapDirection_last)';
    trajectory = [trajectory; arcToTout'];
    
    % Finally, add the final point to the trajectory
    trajectory = [trajectory; t_out'; p_f];
end

function R = rotation(gamma)
    R = [cos(gamma) -sin(gamma); sin(gamma) cos(gamma)];
end