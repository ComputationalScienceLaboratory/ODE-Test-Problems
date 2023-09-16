classdef AscherLinearDAEParameters
    % Parameters for Ascher Linear DAE problem 
    properties
        % Beta is a scalar parameter in the linear model. It affects the stifness 
        % of the problem.
        Beta %MATLAB ONLY: (1,1) {mustBeNumeric} = 1
    end
end
