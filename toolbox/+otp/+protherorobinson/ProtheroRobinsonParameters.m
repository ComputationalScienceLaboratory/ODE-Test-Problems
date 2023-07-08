classdef ProtheroRobinsonParameters
    % Parameters for the Prothero-Robinson problem.
    properties
        % Lambda ($\lambda$) is the eigenvalue of the problem.
        Lambda %MATLAB ONLY: (1,1) {mustBeFinite} = -1

        % Phi is $\phi(t)$, a time-dependent function perturbing the right-hand-side funtion.
        Phi %MATLAB ONLY: {mustBeA(Phi, 'function_handle')} = @sin

        %DPhi is ($\partial \phi / \partial t$),  the time-derivative of Phi.
        DPhi %MATLAB ONLY: {mustBeA(DPhi, 'function_handle')} = @cos
    end
end
