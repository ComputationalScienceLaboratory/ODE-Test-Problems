classdef Canonical < otp.robertson.RobertsonProblem
    % The Robertson problem with the classic coeeficients $K_1 = 4e-2, K2 = 3e7, K3 = 1e4$. This preset is
    % referred to as "ROBER" in :cite:p:`HW96` (pg 144).
    methods
        function obj = Canonical
            % Create the Canonical Robertson problem object.
            %
            % Parameters
            % ----------
            %
            % Returns
            % -------
            % obj : RobertsonProblem
            %    The constructed problem.
            
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
