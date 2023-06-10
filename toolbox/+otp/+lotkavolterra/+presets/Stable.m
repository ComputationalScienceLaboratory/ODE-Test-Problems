classdef Stable  < otp.lotkavolterra.LotkaVolterraProblem

    methods
        function obj = Stable
            
            params = otp.lotkavolterra.LotkaVolterraParameters;
            params.PreyBirthRate     = 1;
            params.PreyDeathRate     = 1;
            params.PredatorDeathRate = 1;
            params.PredatorBirthRate = 1;
            
            y0 = [1; 1];
            tspan = [0 50];
            
            obj = obj@otp.lotkavolterra.LotkaVolterraProblem(tspan, y0, params);
            
        end
    end
    
end
