classdef ProtheroRobinsonProblem < otp.Problem
    % The Prothero–Robinson problem :cite:p:`PR74` is the linear ODE
    % 
    % $$y' = \lambda (y - \phi(t)) + \phi'(t).$$
    %
    % This simple problem is used to test for order reduction and S-stability of time-stepping schemes. With initial
    % condition $y_0 = \phi(t_0)$, the exact solution is $y(t) = \phi(t)$ independent of $\lambda$. Therefore, any
    % errors introduced by the numerical scheme can be measured easily.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------+
    % | Type                | ODE                               |
    % +---------------------+-----------------------------------+
    % | Number of Variables | 1                                 |
    % +---------------------+-----------------------------------+
    % | Stiff               | typically, depending on $\lambda$ |
    % +---------------------+-----------------------------------+
    %
    % Example
    % -------
    % >>> p = otp.protherorobinson.presets.Canonical(-10);
    % >>> sol = p.solve();
    % >>> norm(p.solveExactly(sol.x) - sol.y)

    methods
        function obj = ProtheroRobinsonProblem(timeSpan, y0, parameters)
            % Create a Prothero–Robinson problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(:, 2)
            %    The initial conditions.
            % parameters : ProtheroRobinsonParameters
            %    The parameters.
            %
            % Returns
            % -------
            % obj : ProtheroRobinsonProblem
            %    The constructed problem.
            obj@otp.Problem('Prothero-Robinson', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            lambda = obj.Parameters.Lambda;
            phi = obj.Parameters.Phi;
            dphi = obj.Parameters.DPhi;
            
            obj.RHS = otp.RHS(@(t, y) otp.protherorobinson.f(t, y, lambda, phi, dphi), ...
                'Jacobian', otp.protherorobinson.jacobian(lambda, phi, dphi));
        end
        
        function y = internalSolveExactly(obj, t)
            if ~isequal(obj.Y0, obj.Parameters.Phi(obj.TimeSpan(1)))
                error('OTP:noExactSolution', 'An exact solution is unavailable for this initial condition');
            end
            
            y = obj.Parameters.Phi(t);
        end
    end
end
