        %% compute_direction
        % this function calculates the the direction, in degrees, of the
        % dots for each trials based on the previously computed correct
        % sides
        function direction = compute_direction(correct_side)
            direction = correct_side;
            direction(direction == -1) = 270;
            direction(direction == 1) = 90;
        end
        