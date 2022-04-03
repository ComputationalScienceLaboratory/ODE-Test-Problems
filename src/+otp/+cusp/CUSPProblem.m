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
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, ...
                newParameters);
            
            y0Len = length(newY0);
            gridPts = 3 * newParameters.Size;
            
            if y0Len ~= gridPts
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    y0Len, gridPts);
            end
        end
        
        function onSettingsChanged(obj)
            n = obj.Parameters.Size;
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
