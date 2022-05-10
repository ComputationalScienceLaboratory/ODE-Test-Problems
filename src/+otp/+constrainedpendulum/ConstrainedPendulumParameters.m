classdef ConstrainedPendulumParameters
    %CONSTRAINEDPENDULUMPARAMETERS
    properties
        %Gravity defines the magnitude of acceleration towards the ground
        Gravity %MATLAB ONLY: (1,1) {mustBeNonnegative}
        %Mass defines the mass of the pendulum
        Mass %MATLAB ONLY: (1,1) {mustBeNonnegative}
        %Length defines the length of the pendulum
        Length %MATLAB ONLY: (1,1) {mustBeNonnegative}
    end
end
