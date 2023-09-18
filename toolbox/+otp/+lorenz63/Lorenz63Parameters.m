classdef Lorenz63Parameters < otp.Parameters
    % Parameters for the Lorenz '63 problem.

    properties
        % A representation of the Prandtl number.
        Sigma %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}

        % A representation of the Rayleigh number.
        Rho %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
        
        % A geometric factor.
        Beta %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
    end

    methods
        function obj = Lorenz63Parameters(varargin)
            obj = obj@otp.Parameters(varargin{:});
        end
    end
end
