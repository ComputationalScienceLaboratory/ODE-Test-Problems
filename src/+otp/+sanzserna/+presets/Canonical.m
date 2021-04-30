classdef Canonical < otp.sanzserna.SanzSernaProblem
    methods
        function obj = Canonical(m)
            if nargin < 1
                m = 32;
            end
            x = linspace(1/m + 1, 2, m).';
            obj = obj@otp.sanzserna.SanzSernaProblem([0, 1], x, struct);
        end
    end
end