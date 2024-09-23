classdef Parameters
    % A superclass for the parameters of a differential equation.
    %
    % Subclasses of this class specify mutable properties associated with an :class:`otp.Problem`.
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
            
            if mod(nargin, 2) == 1
                error('OTP:invalidArgument', 'Arguments to Parameters should be name-value pairs');
            end
            
            for i = 1:2:nargin
                obj.(varargin{i}) = varargin{i + 1};
            end
        end
    end
end
