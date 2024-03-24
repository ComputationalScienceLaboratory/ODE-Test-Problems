classdef PendulumParameters < otp.Parameters
    % Parameters for the pendulum problem.
    
    properties
        %GRAVITY is acceleration due to gravity
        Gravity %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        %MASSES of the nodes of the pendulum
        Masses %MATLAB ONLY: (:,1) {otp.utils.validation.mustBeNumerical}

        %LENGTHS between the nodes of the pendulums
        Lengths %MATLAB ONLY: (:,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = PendulumParameters(varargin)
            % Create a pendulum parameters object.
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
