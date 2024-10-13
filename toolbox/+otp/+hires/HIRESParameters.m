classdef HIRESParameters < otp.Parameters
    % Parameters for the HIRES problem.

    properties
        % The stiffness parameter $ε$ for the "cusp catastrophe" model.
        K1 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        K2 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        K3 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        K4 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        K5 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        K6 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        KPlus %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        KMinus %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        KStar %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The diffusion coefficient $σ$ for all three variables.
        OKS %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = HIRESParameters(varargin)
            % Create a HIRES parameters object.
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

