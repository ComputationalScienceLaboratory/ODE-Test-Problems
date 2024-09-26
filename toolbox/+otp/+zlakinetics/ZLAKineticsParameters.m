classdef ZLAKineticsParameters < otp.Parameters
    % Parameters for the ZLA kinetics problem.
    
    properties
        %k are the reaction rates of ancillary reactions
        k %MATLAB ONLY: (1,4) {otp.utils.validation.mustBeNumerical} = [18.7, 0.58, 0.09, 0.42];

        %K is the ZLA reaction rate
        K %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical} = 34.4;

        %KLA is the mass transfer coefficient
        KlA %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical} = 3.3;

        %KS is the equilibrium constant
        Ks %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical} = 115.83;

        %PCO2 is the partial CO_2 pressure
        PCO2 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical} = 0.9;

        %H is the Henry constant
        H %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical} = 737;
    end

    methods
        function obj = ZLAKineticsParameters(varargin)
            % Create a ZLA kinetics parameters object.
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
