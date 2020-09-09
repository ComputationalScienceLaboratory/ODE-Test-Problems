classdef KuramotoSivashinskyProblem < otp.Problem
    
    methods
        function obj = KuramotoSivashinskyProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Kuramoto-Sivashinsky', [], timeSpan, y0, parameters);
        end
    end
    
    methods
        function soly = solution2real(soly)
            
            if isstruct(soly)
                soly.y = real(ifft(soly.y));
            else
                soly = real(ifft(soly.')).';
            end
            
        end
        
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            
            L = obj.Parameters.L;
            
            N = obj.NumVars;
            
            div = L/(2*pi);
            
            k = (1i*[0:(N/2 - 1), 0, (-N/2 + 1):-1].'/div);
            k2 = k.^2;
            k4 = k.^4;

            obj.Rhs = otp.Rhs(@(t, u) otp.kuramotosivashinsky.f(t, u, k, k2, k4), ...
                otp.Rhs.FieldNames.Jacobian, ...
                @(t, u) otp.kuramotosivashinsky.jac(t,u, k, k2, k4), ...
                otp.Rhs.FieldNames.JacobianVectorProduct, ...
                @(t, u, v) otp.kuramotosivashinsky.jvp(t, u, v, k, k2, k4), ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, ...
                @(t, u, v) otp.kuramotosivashinsky.javp(t, u, v, k, k2, k4));
            
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            if mod(numel(newY0), 2) ~= 0
                error('The problem size has to be an even integer.');
            end
            
            otp.utils.StructParser(newParameters) ...
                .checkField('L', 'scalar', 'finite', 'positive');
            
        end
    end
end
