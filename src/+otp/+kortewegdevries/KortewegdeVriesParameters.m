classdef KortewegdeVriesParameters
    %KORTEWEGDEVRIES PARAMETERS
    %
    properties

        % Domain of solution for the PDE
        Domain %MATLAB ONLY: (1,2) {mustBeFinite} = [-10, 10]
        % Ratio between derivatives for nonlinear advection.
        % theta (u^2)_x and (1 - theta)(2u)u_x
        Theta %MATLAB ONLY: (1,1) {mustBeFinite, mustBeInRange(theta, 0, 1)} = 0
        % Coefficient of nonlinear advection u u_x and (u^2)_x: alpha
        Alpha %MATLAB ONLY: (1,1) {mustBeFinite} = -3
        % Coefficient of linear advection u_x: nu
        Nu %MATLAB ONLY: (1,1) {mustBeFinite} = -1
        % Coefficient of u_xxx: rho
        Rho %MATLAB ONLY: (1,1) {mustBeFinite} = 0

    end

end
