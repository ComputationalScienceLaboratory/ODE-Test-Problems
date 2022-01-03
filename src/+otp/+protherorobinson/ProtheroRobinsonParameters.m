classdef ProtheroRobinsonParameters
    properties
        %LAMBDA is the eigenvalue of the problem
        Lambda %MATLAB ONLY: (1,1) {mustBeFinite} = -1
        %PHI is a function perturbing the Rhs in time
        Phi %MATLAB ONLY: {mustBeA(Phi, 'function_handle')} = @sin
        %DPHI is the derivative of Phi
        DPhi %MATLAB ONLY: {mustBeA(DPhi, 'function_handle')} = @cos
    end
end
