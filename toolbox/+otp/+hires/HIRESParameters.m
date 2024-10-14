classdef HIRESParameters < otp.Parameters
    % Parameters for the HIRES problem.

    properties
        % The reaction rate $k_1$.
        K1 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k_2$.
        K2 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k_3$.
        K3 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k_4$.
        K4 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k_5$.
        K5 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k_6$.
        K6 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k_{+}$.
        KPlus %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k_{-}$.
        KMinus %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The reaction rate $k^*$.
        KStar %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        % The source term $o_{k_s}$.
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

