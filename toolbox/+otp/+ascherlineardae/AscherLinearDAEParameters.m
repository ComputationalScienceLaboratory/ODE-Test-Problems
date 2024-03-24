classdef AscherLinearDAEParameters < otp.Parameters
    % Parameters for Ascher Linear DAE problem.
    
    properties
        % A scalar parameter $β$ in the linear model. It affects the stifness of the problem.
        Beta %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = AscherLinearDAEParameters(varargin)
            % Create a Ascher Linear DAE parameters object.
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
