classdef Canonical < otp.pendulum.PendulumProblem
    methods
        function obj = Canonical(varargin)
            p = inputParser();
            p.KeepUnmatched = true;
            p.addParameter('NumBobs', 1);
            p.parse(varargin{:});
            numBobs = p.Results.NumBobs;
            
            tspan = [0, 10];

            vecOnes = ones(numBobs, 1);
            y0 = [pi/2*vecOnes; zeros(numBobs, 1)];

            unmatched = namedargs2cell(p.Unmatched);
            params = otp.pendulum.PendulumParameters( ...
                'Gravity', otp.utils.PhysicalConstants.EarthGravity, ...
                'Lengths', vecOnes, ...
                'Masses', vecOnes, ...
                unmatched{:});

            obj = obj@otp.pendulum.PendulumProblem(tspan, y0, params);
        end
    end
end
