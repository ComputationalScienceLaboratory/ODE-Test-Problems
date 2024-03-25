classdef NBodyParameters < otp.Parameters
    % Parameters for the N-body problem.
    
    properties
        SpatialDim %MATLAB ONLY: (1,1) {mustBeInteger, mustBePositive} = 2

        %Masses are the masses of the objects
        Masses %MATLAB ONLY: (:,1) {otp.utils.validation.mustBeNumerical}

        %GravitationalConstant is exactly what it says on the box
        GravitationalConstant %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}

        %SofteningLength is a heuristic parameter that avoids singularities
        SofteningLength %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical, mustBeNonnegative}
    end

    methods
        function obj = NBodyParameters(varargin)
            % Create an N-body parameters object.
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
