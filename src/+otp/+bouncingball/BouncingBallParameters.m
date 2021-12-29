classdef BouncingBallParameters
    %BOUNCINGBALLPARAMETERS 
    properties
        %Gravity defines the magnitude of acceleration towards the ground
        Gravity (1,1) {mustBeNonnegative}
        %Ground is a function defining the ground in terms of space
        Ground {mustBeA(Ground, 'function_handle')} = @(x) 0
        %GroundSlope is the slope (derivative) of the ground
        GroundSlope {mustBeA(GroundSlope, 'function_handle')} = @(x) 0
    end
end

