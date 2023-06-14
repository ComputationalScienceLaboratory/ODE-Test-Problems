classdef QuadraticParameters
    %QUADRATICPARAMETERS
    %
    properties
        %A is the translation term (degree 0)
        A %MATLAB ONLY: (:, 1) {mustBeNumeric}
        %B is the linear term (degree 1)
        B %MATLAB ONLY: (:, :) {mustBeNumeric}
        %C is the quadratic term (degree 2)
        C %MATLAB ONLY: (:, :, :) {mustBeNumeric}
    end
end
