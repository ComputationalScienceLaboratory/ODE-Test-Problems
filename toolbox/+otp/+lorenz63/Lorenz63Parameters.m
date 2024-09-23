classdef Lorenz63Parameters < otp.Parameters
    % Parameters for the Lorenz '63 problem.

    properties
        % A representation of the Prandtl number.
        Sigma %MATLAB ONLY: (1, 1) {otp.utils.validation.mustBeNumerical}

        % A representation of the Rayleigh number.
        Rho %MATLAB ONLY: (1, 1) {otp.utils.validation.mustBeNumerical}
        
        % A geometric factor.
        Beta %MATLAB ONLY: (1, 1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = Lorenz63Parameters(varargin)
            % Create a Lorenz '63 parameters object.
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
