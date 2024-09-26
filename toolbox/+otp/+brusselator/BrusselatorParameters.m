classdef BrusselatorParameters < otp.Parameters
    % Parameters for the Brusselator problem.
    
    properties
        % The concentration of excess reactant $\ce{A}$ in the Brusselator reaction.
        A %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The concentration of excess reactant $\ce{B}$ in the Brusselator reaction.
        B %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = BrusselatorParameters(varargin)
            % Create a Brusselator parameters object.
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
