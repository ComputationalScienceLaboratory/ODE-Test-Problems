classdef Canonical < otp.arenstorf.Arenstorf
    methods
        function obj = Canonical(varargin)
                 
            p = inputParser;
            addParameter(p, 'm1', 0.012277471, @isscalar);
            parse(p, varargin{:});
            s = p.Results;
            
            params.m1 = s.m1;
            params.m2 = 1-params.m1;
                
            y0 = [0.994; 0; 0; -2.00158510637908252240537862224];
            tspan = [0,17.0652165601579625588917206249];
            
            obj = obj@otp.arenstorf.Arenstorf(tspan, y0, params);
        end

    end
end