classdef Parameters
    methods
        function obj = Parameters(varargin)
            extras = struct(varargin{:});
            fields = fieldnames(extras);
            
            for i = 1:length(fields)
                f = fields{i};
                obj.(f) = extras.(f);
            end
        end
    end
end
