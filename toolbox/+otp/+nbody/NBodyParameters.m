classdef NBodyParameters
    %NBODYPARAMETERS
    % 
    properties
        SpatialDim %MATLAB ONLY: (1,1) {mustBeInteger, mustBePositive} = 2
        %Masses are the masses of the objects
        Masses %MATLAB ONLY: (:,1) {mustBePositive} = 1
        %GravitationalConstant is exactly what it says on the box
        GravitationalConstant %MATLAB ONLY: (1,1) {mustBePositive} = 1
        %SofteningLength is a heuristic parameter that avoids singularities
        SofteningLength %MATLAB ONLY: (1,1) {mustBeNonnegative} = 0
    end
end
