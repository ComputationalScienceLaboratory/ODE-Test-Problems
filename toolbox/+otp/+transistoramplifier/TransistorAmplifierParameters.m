classdef TransistorAmplifierParameters < otp.Parameters
    % Parameters for the transistor amplifier problem.
    
    properties
        %C are the magnitudes of the change in voltage of the capacitors
        C %MATLAB ONLY: (1,5) {otp.utils.validation.mustBeNumerical}

        %R denotes the resistances
        R %MATLAB ONLY: (1,10) {otp.utils.validation.mustBeNumerical}

        %UB is the operating voltage
        Ub %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        %UF is an auxillary voltage
        UF %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        %ALPHA controls the current coming through the gate
        Alpha %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        %BETA is an auxillary constant
        Beta %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = TransistorAmplifierParameters(varargin)
            % Create a transistor amplifier parameters object.
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
