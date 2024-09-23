classdef LotkaVolterraParameters < otp.Parameters
    % Parameters for the Lotka–Volterra problem.
    
    properties
        %PREYBIRTHRATE determines the rate at which the prey is born it is a source term
        PreyBirthRate %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1

        %PREYDEATHRATE determines how fast the prey is killed by the predators
        PreyDeathRate %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1

        %PREDATORDEATHRATE is a sink term for the predators
        PredatorDeathRate %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1
        
        %PREDATORBIRTHRATE determines how fast the predators are born based on the amount of prey that exists
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
