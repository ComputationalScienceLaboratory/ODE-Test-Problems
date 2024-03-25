classdef AllenCahnParameters < otp.Parameters
    % Parameters for the Allen–Cahn problem.
    
    properties
        %Size is the dimension of the problem
        Size %MATLAB ONLY: (1,1) {mustBeInteger, mustBePositive} = 1

        %Alpha is non-negative diffusion constant
        Alpha %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        %Beta is a non-negative reaction constant
        Beta %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        %Forcing is a forcing function or constant
        Forcing %MATLAB ONLY: {mustBeA(Forcing, {'numeric', 'function_handle'})}
    end

    methods
        function obj = AllenCahnParameters(varargin)
            % Create an Allen–Cahn parameters object.
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
