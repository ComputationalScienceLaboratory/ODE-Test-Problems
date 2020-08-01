classdef Canonical < otp.arenstorf.ArenstorfProblem
    methods
        function obj = Canonical(varargin)
                 
            p = inputParser;
            p.addParameter('m1', 0.012277471);
            p.parse(varargin{:});
            s = p.Results;
            
            params.m1 = s.m1;
            params.m2 = 1-params.m1;
                
            y0 = [0.994; 0; 0; -2.00158510637908252240537862224];
            tspan = [0,17.0652165601579625588917206249];
            
            obj = obj@otp.arenstorf.ArenstorfProblem(tspan, y0, params);
        end

    end
end