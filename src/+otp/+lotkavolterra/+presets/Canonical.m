classdef Canonical  < otp.lotkavolterra.LotkaVolterraProblem

    methods
        function obj = Canonical
            
            params.preyBirthRate     = 1;
            params.preyDeathRate     = 1;
            params.predatorDeathRate = 1;
            params.predatorBirthRate = 1;
            
            y0 = [1; 2];
            tspan = [0 50];
            
            obj = obj@otp.lotkavolterra.LotkaVolterraProblem(tspan, y0, params);
            
        end
    end
    
end
