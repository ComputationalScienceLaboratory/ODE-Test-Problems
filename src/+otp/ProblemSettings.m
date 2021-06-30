classdef (Hidden) ProblemSettings
    properties
        ExpectedNumVars(1, 1) double {mustBeNonnegative}
        TimeSpan(2, 1) {mustBeNumeric}
        Y0(:, 1) {mustBeNumeric}
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

