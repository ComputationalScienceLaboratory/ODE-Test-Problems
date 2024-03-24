classdef BouncingBallParameters < otp.Parameters
    % Parameters for the bouncing ball problem.

    properties
        % The magnitude of acceleration towards the ground.
        Gravity %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBeNonnegative}

        % A function defining the ground in terms of space.
        Ground %MATLAB ONLY: (1,1) {mustBeA(Ground, 'function_handle')} = @(x) 0

        % The slope (derivative) of the ground.
        GroundSlope %MATLAB ONLY: (1,1) {mustBeA(GroundSlope, 'function_handle')} = @(x) 0
    end

    methods
        function obj = BouncingBallParameters(varargin)
            % Create a bouncing ball parameters object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. A name can be any property of this class, and the subsequent
            %    value initializes that property.

            obj = obj@otp.Parameters(varargin{:});
        end
    end
end

