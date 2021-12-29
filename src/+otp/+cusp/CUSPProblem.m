classdef CUSPProblem < otp.Problem
    %CUSPPROBLEM
    
    properties (Access = private, Constant)
        VarNames = 'yab';
    end
    
    properties (SetAccess = private)
        RhsStiff
        RhsNonstiff
        RhsDiffusion
        RhsReaction
    end
    
    methods
        function obj = CUSPProblem(timeSpan, y0, parameters)
            obj@otp.Problem('CUSP Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            N = obj.Parameters.Size;
            epsilon = obj.Parameters.Epsilon;
            sigma = obj.Parameters.Sigma;
            
            domain = [0, 1];
            
            L = otp.utils.pde.laplacian(N, domain, sigma, 'C');
            
            obj.Rhs = otp.Rhs(@(t, y) otp.cusp.f(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jac(t, y, epsilon, L));
            
            obj.RhsStiff = otp.Rhs(@(t, y) otp.cusp.fstiff(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacstiff(t, y, epsilon, L));
            
            obj.RhsNonstiff = otp.Rhs(@(t, y) otp.cusp.fnonstiff(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacnonstiff(t, y, epsilon, L));
              
            obj.RhsDiffusion = otp.Rhs(@(t, y) otp.cusp.fdiffusion(t, y, epsilon, L), ...
                'Jacobian', otp.cusp.jacdiffusion(epsilon, L));
              
            obj.RhsReaction = otp.Rhs(@(t, y) otp.cusp.freaction(t, y, epsilon, L), ...
                'Jacobian', @(t, y) otp.cusp.jacreaction(t, y, epsilon, L));
        end

        function label = internalIndex2label(obj, index)
            n = obj.Parameters.N;
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
