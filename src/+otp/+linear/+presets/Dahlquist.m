classdef Dahlquist < otp.linear.LinearProblem
    %DAHLQUIST
    %
    methods
        function obj = Dahlquist(A)
            if nargin < 1 || isempty(A)
                A = {-1};
            end

            params = otp.linear.LinearParameters;
            params.A = A;
            
            obj = obj@otp.linear.LinearProblem([0, 1], ones(size(params.A{1}, 1), 1), params);
        end
    end
end
