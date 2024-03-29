classdef LienardParameters < otp.Parameters
    % Parameters for the Lienard problem.
    
    properties
        %F is a function representing the non-linear damping
        F %MATLAB ONLY: {mustBeA(F, 'function_handle')} = @(x) 0

        %DF is the derivative of F
        DF %MATLAB ONLY: {mustBeA(DF, 'function_handle')} = @(x) 0

        %G is a function controlling the stiffness and restoring forces
        G %MATLAB ONLY: {mustBeA(G, 'function_handle')} = @(x) 0

        %DG is the derivative of G
        DG %MATLAB ONLY: {mustBeA(DG, 'function_handle')} = @(x) 0

        %P is usually a periodic funcgtion controlling the forcing
        P %MATLAB ONLY: {mustBeA(P, 'function_handle')} = @(t) 0

        %DP is the derivative of P
        DP %MATLAB ONLY: {mustBeA(DP, 'function_handle')} = @(t) 0
    end

    methods
        function obj = LienardParameters(varargin)
            % Create a Lienard parameters object.
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
