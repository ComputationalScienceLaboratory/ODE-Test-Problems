classdef ProtheroRobinsonParameters < otp.Parameters
    % Parameters for the Prothero–Robinson problem.
    
    properties
        % The stiffness parameter and eigenvalue of the Jacobian $λ$.
        Lambda %MATLAB ONLY: (1,1) {mustBeFinite} = -1

        % The function $φ(t)$.
        Phi %MATLAB ONLY: {mustBeA(Phi, 'function_handle')} = @sin

        % The time derivative of $φ(t)$.
        DPhi %MATLAB ONLY: {mustBeA(DPhi, 'function_handle')} = @cos
    end

    methods
        function obj = ProtheroRobinsonParameters(varargin)
            % Create a Prothero–Robinson parameters object.
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
