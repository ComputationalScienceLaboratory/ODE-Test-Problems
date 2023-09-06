classdef AscherLinearDAEParameters
    % Parameters for Ascher Linear DAE problem 
    properties
        % Beta is a scalar parameter in the linear model. It also affects the initial condition
        % of the algebraic variable.
        Beta %MATLAB ONLY: (1,1) {mustBeNumeric} = 0.5
    end
end
