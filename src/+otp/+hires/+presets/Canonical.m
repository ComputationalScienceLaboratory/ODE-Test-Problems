classdef Canonical < otp.hires.HiresProblem
    methods
        function obj = Canonical
            obj = obj@otp.hires.HiresProblem([0 321.8122], [1; 0; 0; 0; 0; 0; 0; 0.0057], struct);
        end
    end
end