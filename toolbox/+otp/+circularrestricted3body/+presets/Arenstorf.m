classdef Arenstorf < otp.circularrestricted3body.CR3BPProblem
    % One period of a satellite moving in an Earth-Moon system on a planar
    % orbit. The original orbit was derived in :cite:p:`Are63` for the
    % planar circular restricted three body problem, and the setting from
    % which this preset is derived is taken form pages 129--130 of
    % :cite:p:`HNW93`.
    
    methods
        function obj = Arenstorf(varargin)
            % Create the Arenstorf CR3BP problem object.
            
            params = otp.circularrestricted3body.CR3BPParameters(...
                'Mu', 0.012277471, ...
                'SoftFactor', 0, ...
                varargin{:});
            cls = class(params.Mu);

            % Decimals converted to rational to support multiple data types
            y0 = [cast(497, cls) / cast(500, cls); ...
                cast(0, cls); ...
                cast(0, cls); ...
                cast(-823970832321143, cls) / cast(411659154384760, cls)];
            tspan = [cast(0, cls); ...
                cast(4541277234950502, cls) / cast(266113073862361, cls)];
            
            obj = obj@otp.circularrestricted3body.CR3BPProblem(tspan, y0, params);
        end

    end
end
