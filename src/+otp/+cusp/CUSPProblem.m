classdef CUSPProblem < otp.Problem
    %CUSPPROBLEM
    
    properties (Access = private, Constant)
        VarNames = 'yab';
    end
    
    properties (SetAccess = private)
       RHSStiff
       RHSNonstiff
       RHSDiffusion
       RHSReaction
    end
    
    methods
        function obj = CUSPProblem(timeSpan, y0, parameters)
            obj@otp.Problem('CUSP Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            n = obj.Parameters.Size;
            epsilon = obj.Parameters.Epsilon;
            sigma = obj.Parameters.Sigma;
            
            domain = [0, 1];
            
            L = otp.utils.pde.laplacian(n, domain, sigma, 'C');
            
            obj.RHS = otp.RHS(@(t, y) otp.cusp.f(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobian(t, y, epsilon, L), ...
                'Vectorized', 'on');
            
            obj.RHSStiff = otp.RHS(@(t, y) otp.cusp.fstiff(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobianstiff(t, y, epsilon, L), ...
                'Vectorized', 'on');
            
            obj.RHSNonstiff = otp.RHS(@(t, y) otp.cusp.fnonstiff(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobiannonstiff(t, y, epsilon, L), ...
                'Vectorized', 'on');
              
            obj.RHSDiffusion = otp.RHS(@(t, y) otp.cusp.fdiffusion(t, y, epsilon, L), ...
                'Jacobian', otp.cusp.jacobiandiffusion(epsilon, L), ...
                'Vectorized', 'on');
              
            obj.RHSReaction = otp.RHS(@(t, y) otp.cusp.freaction(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacobianreaction(t, y, epsilon, L), ...
                'Vectorized', 'on');
        end

        function label = internalIndex2label(obj, index)
            n = obj.Parameters.Size;
            label = sprintf('%c_{%d}', obj.VarNames(ceil(index / n)), mod(index - 1, n) + 1);
        end
        
        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, ...
                'vars', reshape(1:obj.NumVars, [], otp.utils.PhysicalConstants.ThreeD), ...
                'xlabel', obj.VarNames(1), ...
                'ylabel', obj.VarNames(2), ...
                'zlabel', obj.VarNames(3), ...
                varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.PhaseSpaceMovie('title', obj.Name, ...
                'vars', reshape(1:obj.NumVars, [], otp.utils.PhysicalConstants.ThreeD), ...
                'xlabel', obj.VarNames(1), ...
                'ylabel', obj.VarNames(2), ...
                'zlabel', obj.VarNames(3), ...
                varargin{:});
            mov.record(t, y);
        end
    end
end
