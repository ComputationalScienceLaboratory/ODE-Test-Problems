classdef CUSPParameters < otp.Parameters
    % Parameters for the CUSP problem.

    properties
        % The stiffness parameter $ε$ for the "cusp catastrophe" model.
        Epsilon %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        Sigma %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = CUSPParameters(varargin)
            % Create a CUSP parameters object.
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

