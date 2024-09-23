classdef Canonical < otp.sanzserna.SanzSernaProblem
    methods
        function obj = Canonical(varargin)
            p = inputParser();
            p.KeepUnmatched = true;
            p.addParameter('NumGridCells', 32);
            p.parse(varargin{:});
            numGridCells = p.Results.NumGridCells;

            tspan = [0, 1];
            y0 = linspace(1/numGridCells + 1, 2, numGridCells).';
            
            unmatched = namedargs2cell(p.Unmatched);
            params = otp.sanzserna.SanzSernaParameters(unmatched{:});

            obj = obj@otp.sanzserna.SanzSernaProblem(tspan, y0, params);
        end
    end
end
