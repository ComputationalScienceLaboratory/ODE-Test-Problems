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
            
            obj.RHS = otp.RHS(@(t, u) otp.kuramotosivashinsky.f(t, u, ik, k24), ...
                'Jacobian', ...
                @(t, u) otp.kuramotosivashinsky.jac(t,u, ik, k24), ...
                'JacobianVectorProduct', ...
                @(t, u, v) otp.kuramotosivashinsky.jvp(t, u, v, ik, k24), ...
                'JacobianAdjointVectorProduct', ...
                @(t, u, v) otp.kuramotosivashinsky.javp(t, u, v, ik, k24));
        end
    end
end
