classdef RobertsonParameters
    % Parameters for the Robertson problem.
    properties
        % Reaction rate $K_1$
        K1 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
        % Reaction rate $K_2$
        K2 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
        % Reaction rate $K_3$
        K3 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
    end
end
