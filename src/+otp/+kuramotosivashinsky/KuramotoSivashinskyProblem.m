classdef KuramotoSivashinskyProblem < otp.Problem
    
    methods
        function obj = KuramotoSivashinskyProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Kuramoto-Sivashinsky', [], timeSpan, y0, parameters);
        end
    end
    
    methods
        function soly = convert2grid(~, soly)
            
            soly = abs(ifft(soly));
            
        end
        
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            N = obj.NumVars;
            
            k = 2 * pi * [0:(N/2 - 1), 0, (-N/2 + 1):-1].' / obj.Parameters.L;
            ik = 1i * k;
            k24 = k.^2 - k.^4;
            
            obj.Rhs = otp.Rhs(@(t, u) otp.kuramotosivashinsky.f(t, u, ik, k24), ...
                otp.Rhs.FieldNames.Jacobian, ...
                @(t, u) otp.kuramotosivashinsky.jac(t,u, ik, k24), ...
                otp.Rhs.FieldNames.JacobianVectorProduct, ...
                @(t, u, v) otp.kuramotosivashinsky.jvp(t, u, v, ik, k24), ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, ...
                @(t, u, v) otp.kuramotosivashinsky.javp(t, u, v, ik, k24));
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
