classdef QuasiGeostrophicParameters
    %QUASIGEOSTROPHICPARAMETERS
    %
    properties
        %Nx is the number of grid points in the x direction
        Nx %MATLAB ONLY: (1,1) {mustBeFinite, mustBeInteger, mustBePositive} = 63
        %Ny is the number of grid points in the y direction
        Ny %MATLAB ONLY: (1,1) {mustBeFinite, mustBeInteger, mustBePositive} = 127
        %Re is the Reynolds number
        Re %MATLAB ONLY: (1,1) {mustBeFinite, mustBePositive} = 450
        %Ro is the Rossby number
        Ro %MATLAB ONLY: (1,1) {mustBeFinite} = 0.0036
        %ADlambda is the approximate deconvolution parameter
        ADLambda %MATLAB ONLY: (1,1) {mustBeFinite, mustBePositive} = 1
        %ADPasses defines how many passes of the filter to do
        ADPasses %MATLAB ONLY: (1,1) {mustBeFinite, mustBePositive, mustBeInteger} = 4
    end
end
