classdef PendulumParameters
    properties
        %GRAVITY is acceleration due to gravity
        Gravity %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 9.8
        %MASSES of the nodes of the pendulum
        Masses %MATLAB ONLY: (:,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
        %LENGTHS between the nodes of the pendulums
        Lengths %MATLAB ONLY: (:,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
    end
end
