classdef VanderpolParameters< otp.Parameters
    % Parameters for the Van der Pol problem.
    
    properties
        %EPSILON is a weakly-enforced parameter on the constraint.
        Epsilon %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = VanderpolParameters(varargin)
            % Create a Van der Pol parameters object.
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
