classdef ProtheroRobinsonParameters
    % Parameters for the Prothero–Robinson problem.
    properties
        % The stiffness parameter and eigenvalue of the Jacobian $\lambda$.
        Lambda %MATLAB ONLY: (1,1) {mustBeFinite} = -1

        % The function $\phi(t)$.
        Phi %MATLAB ONLY: {mustBeA(Phi, 'function_handle')} = @sin

        % The time derivative of $\phi(t)$.
        DPhi %MATLAB ONLY: {mustBeA(DPhi, 'function_handle')} = @cos
    end
end
