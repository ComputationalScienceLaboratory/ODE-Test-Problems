classdef Dahlquist < otp.linear.LinearProblem
    %DAHLQUIST
    %
    methods
        function obj = Dahlquist(varargin)
            params = otp.linear.LinearParameters;
            
            if nargin == 0
                params.Lambda = {-1};
            else
                params.Lambda = varargin;
            end
            
            y0 = ones(size(params.Lambda{1}, 1), 1);
            
            obj = obj@otp.linear.LinearProblem([0, 1], y0, params);
        end
    end
end
