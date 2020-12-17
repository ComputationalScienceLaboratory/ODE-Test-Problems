classdef CUSPProblem < otp.Problem
    % See Hairer and Wanner, Solving ODEs II, p. 147
    
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
            N = obj.Parameters.N;
            epsilon = obj.Parameters.epsilon;
            sigma = obj.Parameters.sigma;
            
            domain = [0, 1];
            
            L = otp.utils.pde.laplacian(N, domain, sigma, 'C');
            
            obj.Rhs = otp.Rhs(@(t, y) otp.cusp.f(t, y, epsilon, L), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.cusp.jac(t, y, epsilon, L));
            
            obj.RhsStiff = otp.Rhs(@(t, y) otp.cusp.fstiff(t, y, epsilon, L), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.cusp.jacstiff(t, y, epsilon, L));
            
            obj.RhsNonstiff = otp.Rhs(@(t, y) otp.cusp.fnonstiff(t, y, epsilon, L), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.cusp.jacnonstiff(t, y, epsilon, L));
              
            obj.RhsDiffusion = otp.Rhs(@(t, y) otp.cusp.fdiffusion(t, y, epsilon, L), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.cusp.jacdiffusion(t, y, epsilon, L));
              
            obj.RhsReaction = otp.Rhs(@(t, y) otp.cusp.freaction(t, y, epsilon, L), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.cusp.jacreaction(t, y, epsilon, L));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('epsilon', 'finite', 'positive') ...
                .checkField('sigma', 'finite', 'positive');
        end
        
        function label = internalIndex2label(obj, index)
            n = obj.Parameters.N;
            label = sprintf('%c_{%d}', obj.VarNames(ceil(index / n)), mod(index - 1, n) + 1);
        end
        
        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, ...
                'vars', reshape(1:obj.NumVars, [], otp.utils.PhysicalConstants.ThreeDimensional), ...
                'xlabel', obj.VarNames(1), ...
                'ylabel', obj.VarNames(2), ...
                'zlabel', obj.VarNames(3), ...
                varargin{:});
        end
    end
end
