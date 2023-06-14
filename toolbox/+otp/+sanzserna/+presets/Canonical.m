classdef Canonical < otp.sanzserna.SanzSernaProblem
    methods
        function obj = Canonical(numGridCells)
            if nargin < 1 || isempty(numGridCells)
                numGridCells = 32;
            end
            
            params = otp.sanzserna.SanzSernaParameters;

            y0 = linspace(1/numGridCells + 1, 2, numGridCells).';
            obj = obj@otp.sanzserna.SanzSernaProblem([0, 1], y0, params);
        end
    end
end
