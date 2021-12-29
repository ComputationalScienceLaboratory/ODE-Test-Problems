classdef CUSPParameters
    %CUSPPARAMETERS 
    %
    properties
        %SIZE is the desired size of the problem
        Size %MATLAB ONLY: (1,1) {mustBeInteger}
        %EPSILON is the stiffness parameter
        Epsilon %MATLAB ONLY: (1,1) {mustBePositive} = 1e-4
        %SIGMA is the diffusion coefficient
        Sigma %MATLAB ONLY: (1,1)  {mustBePositive} = 1/144
    end
end

