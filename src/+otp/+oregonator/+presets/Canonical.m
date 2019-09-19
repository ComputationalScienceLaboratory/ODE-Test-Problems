classdef Canonical < otp.oregonator.OregonatorProblem
    methods
        function obj = Canonical
            obj = obj@otp.oregonator.OregonatorProblem([0, 360], [1; 2; 3], struct);
        end
    end
end