classdef HiresProblem < otp.Problem
    
    methods
        function obj = HiresProblem(timeSpan, y0, parameters)
            obj@otp.Problem('HIRES', timeSpan, y0, parameters);
        end
        
        function fig = loglog(obj, varargin)
            fig = obj.plot(varargin{:}, 'xscale', 'log', 'yscale', 'log');
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.Rhs = otp.Rhs(@otp.hires.f, ...
                otp.Rhs.FieldNames.Jacobian, @otp.hires.jacobian, ...
                otp.Rhs.FieldNames.JacobianVectorProduct, @otp.hires.jvp, ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, @otp.hires.javp);
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            if length(newY0) ~= 8
                error('Y0 must have 8 components');
            end
        end
    end
end
