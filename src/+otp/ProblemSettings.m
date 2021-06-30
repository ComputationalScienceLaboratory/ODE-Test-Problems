classdef (Hidden) ProblemSettings
    properties
        ExpectedNumVars(1, 1) {mustBeNonnegative}
        TimeSpan(2, 1) {otp.utils.validation.mustBeNumericOrSym}
        Y0(:, 1) {otp.utils.validation.mustBeNumericOrSym}
        Parameters(1, 1)
    end
    
    methods
        function obj = ProblemSettings(expectedNumVars, timeSpan, y0, parameters)
            obj.ExpectedNumVars = expectedNumVars;
            obj.TimeSpan = timeSpan;
            obj.Y0 = y0;
            obj.Parameters = parameters;
        end
    end
end

