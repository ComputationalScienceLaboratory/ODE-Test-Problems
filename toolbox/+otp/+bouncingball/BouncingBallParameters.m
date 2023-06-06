classdef BouncingBallParameters
    %BOUNCINGBALLPARAMETERS 
    properties
        %Gravity defines the magnitude of acceleration towards the ground
        Gravity %MATLAB ONLY: (1,1) {mustBeNonnegative}
        %Ground is a function defining the ground in terms of space
        Ground %MATLAB ONLY: {mustBeA(Ground, 'function_handle')} = @(x) 0
        %GroundSlope is the slope (derivative) of the ground
        GroundSlope %MATLAB ONLY: {mustBeA(GroundSlope, 'function_handle')} = @(x) 0
    end
end

