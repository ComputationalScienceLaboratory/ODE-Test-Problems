classdef LotkaVolterraParameters < otp.Parameters
    % Parameters for the Lotka–Volterra problem.
    
    properties
        % A positive scaler that determines the rate at which the prey is born. 
        PreyBirthRate %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1

        % A positive scaler that determines the rate at which the prey is consumed by the predators.
        PreyDeathRate %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1

        % A positive scaler that determines the rate at which the predators die.
        PredatorDeathRate %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1
        
        % A positive scaler that determines the rate at which the predators are born.
        PredatorBirthRate %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1
    end

    methods
        function obj = LotkaVolterraParameters(varargin)
            % Create a Lotka–Volterra parameters object.
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
