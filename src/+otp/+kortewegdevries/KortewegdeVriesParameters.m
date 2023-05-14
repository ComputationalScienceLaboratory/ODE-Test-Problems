classdef KortewegdeVriesParameters
    %KORTEWEGDEVRIES PARAMETERS
    %
    properties

        % Domain of solution for the PDE
        Domain %MATLAB ONLY: (1,2) {mustBeFinite} = [-10, 10]
        % Discretization for the domain.
        Nx %MATLAB ONLY: (1,1) {mustBeFinite, mustBeInteger, mustBePositive} = 200
        % Function defining the initial condition
        InitialCondition %MATLAB ONLY: (1,1) {validateInitialCondition(InitialCondition)} = @(x) 6*(sech(x).^2)
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

function validateInitialCondition(f)

if ~(isequal(class(f), 'function_handle') && (nargin(f) == 1))
    error('OTP:BadInitialCondition', ['Error setting property ''InitialCondition'' of class ''otp.kortewegdevries.KortewegdeVriesParameters''', ...
        newline ,...
        'Value must be a function_handle taking in one input.'])
end

end
