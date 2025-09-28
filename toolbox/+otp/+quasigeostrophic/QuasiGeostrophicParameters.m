classdef QuasiGeostrophicParameters < otp.Parameters
    % Parameters for the Quasi-geostrophic problem.

    properties
        %Nx is the number of grid points in the x direction
        Nx %MATLAB ONLY: (1,1) {mustBeInteger, mustBePositive} = 63

        %Ny is the number of grid points in the y direction
        Ny %MATLAB ONLY: (1,1) {mustBeInteger, mustBePositive} = 127

        %ReynoldsNumber is the Reynolds number
        ReynoldsNumber %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 450

        %RossbyNumber is the Rossby number
        RossbyNumber %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical} = 0.0036

        %ADlambda is the approximate deconvolution parameter
        ADLambda %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBePositive} = 1

        %ADPasses defines how many passes of the filter to do
        ADPasses %MATLAB ONLY: (1,1) {mustBePositive, mustBeInteger} = 4
    end

    methods
        function obj = QuasiGeostrophicParameters(varargin)
            % Create a quasi-geostrophic parameters object.
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
