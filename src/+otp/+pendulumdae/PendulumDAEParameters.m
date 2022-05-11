classdef PendulumDAEParameters
    %CONSTRAINEDPENDULUMPARAMETERS
    properties
        %GRAVITY is acceleration due to gravity
        Gravity %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 9.8
        %MASSE of the node of the pendulum
        Mass %MATLAB ONLY: (:,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
        %LENGTH to the node of the pendulum
        Length %MATLAB ONLY: (:,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
    end
end
