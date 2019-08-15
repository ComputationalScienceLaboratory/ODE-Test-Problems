classdef Dahlquist < otp.linear.LinearProblem
    methods
        function obj = Dahlquist(varargin)
            if nargin < 1
                params.A = {-1};
            else
                params.A = varargin;
            end
            
            obj = obj@otp.linear.LinearProblem([0, 1], ones(size(params.A{1}, 1), 1), params);
        end
    end
end
