classdef Parameters
    % A superclass for the parameters of a differential equation.
    %
    % Subclasses of this class specify mutable properties associated with a :class:`otp.Problem`.
    %
    % See Also
    % --------
    % otp.Problem.Parameters

    methods
        function obj = Parameters(varargin)
            % Create a parameters object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. A name can be any property defined by a subclass, and the
            %    subsequent value initializes that property.
            extras = struct(varargin{:});
            fields = fieldnames(extras);
            
            for i = 1:length(fields)
                f = fields{i};
                obj.(f) = extras.(f);
            end
        end
    end
end
