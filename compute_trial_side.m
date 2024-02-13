        %% compute_trial_side
        function correct_side = compute_trial_side(left_prior)
            % use priors to randomly select trial sides, here -1 is close
            % and 1 is far
            rng('shuffle');
            correct_side = double(randi([0, 1])>left_prior);
            if correct_side == 0
                correct_side = -1;
            end

        end
        