classdef QuadraticParameters < otp.Parameters
    % Parameters for the quadratic problem.
    
    properties
        %A is the translation term (degree 0)
        A %MATLAB ONLY: (:, 1) {otp.utils.validation.mustBeNumerical}

        %B is the linear term (degree 1)
        B %MATLAB ONLY: (:, :) {otp.utils.validation.mustBeNumerical}

        %C is the quadratic term (degree 2)
        C %MATLAB ONLY: (:, :, :) {otp.utils.validation.mustBeNumerical}
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
