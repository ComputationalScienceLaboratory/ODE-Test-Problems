classdef Canonical < otp.robertson.RobertsonProblem
    % The classic problem with the classic coeeficients
    methods
        function obj = Canonical
            params = otp.robertson.RobertsonParameters;
            params.K1 = 0.04;
            params.K2 = 3e7;
            params.K3 = 1e4;
            
            y0 = [1; 0; 0];
            tspan = [0; 1e11];
            
            obj = obj@otp.robertson.RobertsonProblem(tspan, y0, params);
        end

    end
end
