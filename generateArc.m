function arcPoints = generateArc(startPoint, endPoint, rollerPos, clearanceRadius, wrapDirection)
    % Compute the angles of the start and end points relative to the roller center
    angleStart = atan2(startPoint(2) - rollerPos(2), startPoint(1) - rollerPos(1));
    angleEnd = atan2(endPoint(2) - rollerPos(2), endPoint(1) - rollerPos(1));

    % Generate the arc points
    if strcmpi(wrapDirection, 'CW')
        if angleEnd > angleStart
            angleEnd = angleEnd - 2 * pi;
        end
        angles = linspace(angleStart, angleEnd, 80);  % Adjust the number of points as needed
    else
        if angleStart > angleEnd
            angleStart = angleStart - 2 * pi;
        end
        angles = linspace(angleStart, angleEnd, 80);  % Adjust the number of points as needed
    end

    arcPoints = rollerPos' + clearanceRadius * [cos(angles)' sin(angles)'];
end