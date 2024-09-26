classdef ArenstorfParameters < otp.Parameters
    % Parameters for the Arenstorf problem.
    
    properties
        % The mass of one body, while the other body has mass $\mu' = 1 - \mu$.
        Mu %MATLAB ONLY: (1, 1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = ArenstorfParameters(varargin)
            % Create an Arenstorf parameters object.
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
