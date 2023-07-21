classdef CUSPProblem < otp.Problem
    % A 1D PDE combining a "cusp catastrophe" model with the van der Pol oscillator.
    %
    % The CUSP problem :cite:p:`HW96` (pp. 147-148) is the PDE
    %
    % $$
    % \frac{\partial y}{\partial t} &= -\frac{1}{\varepsilon} (y^3 + a y + b)
    % + \sigma \frac{\partial^2 y}{\partial x^2}, \\
    % \frac{\partial a}{\partial t} &= b + 0.07 v + \sigma \frac{\partial^2 a}{\partial x^2}, \\
    % \frac{\partial b}{\partial t} &= (1 - a^2) b - a - 0.4 y + 0.035 v + \sigma \frac{\partial^2 b}{\partial x^2},
    % $$
    %
    %
    % where $v = u / (u + 0.1)$ and $u = (y - 0.7)(y - 1.3)$. The spatial domain $x \in [0, 1]$ has period boundary
    % conditions. Discretization with second order finite difference on a grid with $N$ cells gives
    %
    % $$
    % y'_i &= -\frac{1}{\varepsilon} (y_i^3 + a_i y_i + b_i) + \sigma N^2 (y_{i-1} - 2 y_i + y_{i+1}) \\
    % a'_i &= b_i + 0.07 v_i + \sigma N^2 (a_{i-1} - 2 a_i + a_{i+1}) \\
    % b'_i &= (1 - a_i^2) b_i - a_i - 0.4 y_i + 0.035 v_i + \sigma N^2  (b_{i-1} - 2 b_i + b_{i+1}),
    % $$
    %
    % where $i = 1, \dots, N$. Values at cell indices $i=0, N+1$ are specificied by the periodic boundary conditions.
    %
    % Notes
    % -----
    % +---------------------+----------------------------------------------------------------------------+
    % | Type                | PDE                                                                        |
    % +---------------------+----------------------------------------------------------------------------+
    % | Number of Variables | arbitrary multiple of 3                                                    |
    % +---------------------+----------------------------------------------------------------------------+
    % | Stiff               | typically, depending on $\varepsilon$, $\sigma$, and number of grid points |
    % +---------------------+----------------------------------------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.cusp.presets.Canonical;
    % >>> sol = problem.solve();
    % >>> problem.plotPhaseSpace(sol, 'View', [45, 45]);
    
    properties (Access = private, Constant)
        NumComps = 3
        VarNames = 'yab'
    end
    
    properties (SetAccess = private)
        % Right-hand side containing the diffusion terms and the reaction terms multiplied by $\varepsilon^{-1}$.
        %
        % This partition of the RHS is used in :cite:p:`JM17`.
        %
        % See Also
        % --------
        % RHSNonstiff
       RHSStiff

        % Right-hand side containing the reaction terms not scaled by $\varepsilon^{-1}$.
        %
        % This partition of the RHS is used in :cite:p:`JM17`.
        %
        % See Also
        % --------
        % RHSStiff
       RHSNonstiff

        % Linear right-hand side containing the diffusion terms.
        %
        % See Also
        % --------
        % RHSReaction
       RHSDiffusion

       % Right-hand side containing the reaction terms.
       %
       % See Also
       % --------
       % RHSDiffusion
       RHSReaction
    end
    
    methods
        function obj = CUSPProblem(timeSpan, y0, parameters)
            % Create a CUSP problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(:, 1)
            %    The initial conditions.
            % parameters : CUSPParameters
            %    The parameters.
            %
            % Returns
            % -------
            % obj : CUSPProblem
            %    The constructed problem.
            obj@otp.Problem('CUSP', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            if mod(obj.NumVars, obj.NumComps) ~= 0
                warning('OTP:inconsistentNumVars', 'NumVars is %d, but should be a multiple of 3', obj.NumVars);
            end

            n = round(obj.NumVars / obj.NumComps);
            epsilon = obj.Parameters.Epsilon;
            sigma = obj.Parameters.Sigma;
            
            domain = [0, 1];
            
            L = otp.utils.pde.laplacian(n, domain, sigma, 'C');
            
            obj.RHS = otp.RHS(@(t, y) otp.cusp.f(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobian(t, y, epsilon, L), ...
                'Vectorized', 'on');
            
            obj.RHSStiff = otp.RHS(@(t, y) otp.cusp.fStiff(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobianStiff(t, y, epsilon, L), ...
                'Vectorized', 'on');
            
            obj.RHSNonstiff = otp.RHS(@(t, y) otp.cusp.fNonstiff(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobianNonstiff(t, y, epsilon, L), ...
                'Vectorized', 'on');
              
            obj.RHSDiffusion = otp.RHS(@(t, y) otp.cusp.fDiffusion(t, y, epsilon, L), ...
                'Jacobian', otp.cusp.jacobianDiffusion(epsilon, L), ...
                'Vectorized', 'on');
              
            obj.RHSReaction = otp.RHS(@(t, y) otp.cusp.fReaction(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobianReaction(t, y, epsilon, L), ...
                'Vectorized', 'on');
        end

        function label = internalIndex2label(obj, index)
            n = round(obj.NumVars / obj.NumComps);
            label = sprintf('%c_{%d}', obj.VarNames(ceil(index / n)), mod(index - 1, n) + 1);
        end
        
        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, ...
                'vars', reshape(1:obj.NumVars, [], obj.NumComps), ...
                'xlabel', obj.VarNames(1), ...
                'ylabel', obj.VarNames(2), ...
                'zlabel', obj.VarNames(3), ...
                varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.PhaseSpaceMovie('title', obj.Name, ...
                'vars', reshape(1:obj.NumVars, [], obj.NumComps), ...
                'xlabel', obj.VarNames(1), ...
                'ylabel', obj.VarNames(2), ...
                'zlabel', obj.VarNames(3), ...
                varargin{:});
            mov.record(t, y);
        end
    end
end
