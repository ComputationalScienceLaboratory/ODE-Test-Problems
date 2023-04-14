classdef Dahlquist < otp.linear.LinearProblem
    %DAHLQUIST
    %
    methods
        function obj = Dahlquist(varargin)
            params = otp.linear.LinearParameters;
            
            if nargin == 0
                params.A = {-1};
            else
                params.A = varargin;
            end
            
            A1 = params.A{1};
            y0 = ones(size(A1, 1), 1, 'like', A1);
            
            obj = obj@otp.linear.LinearProblem([0, 1], y0, params);
        end
    end
end
