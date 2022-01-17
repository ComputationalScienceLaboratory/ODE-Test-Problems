classdef Lorenz63Parameters
    %LORENZ63PARAMETERS User-configurable parameters for the Lorenz 63 problem
    %
    %   See also otp.lorenz63.Lorenz63Problem
    
    properties
        %SIGMA represents the Prandtl number
        Sigma %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}

        % RHO represents the Rayleigh number
        Rho %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
        
        % BETA is some geometric factor
        Beta %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
    end
end
