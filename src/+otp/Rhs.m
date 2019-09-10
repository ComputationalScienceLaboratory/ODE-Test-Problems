classdef Rhs < dynamicprops
    properties (SetAccess = immutable)
        F
    end
    
    properties (Constant, Hidden)
        FieldNames = struct( ...
            'Jacobian',                     'Jacobian', ...
            'JacobianVectorProduct',        'JacobianVectorProduct', ...
            'JacobianAdjointVectorProduct', 'JacobianAdjointVectorProduct', ...
            'JacobianParameters',           'JacobianParameters', ...
            'HessianVectorProduct',         'HessianVectorProduct', ...
            'HessianAdjointVectorProduct',  'HessianAdjointVectorProduct', ...
            'JPattern',                     'JPattern', ...
            'Events',                       'Events', ...
            'OnEvent',                      'OnEvent');
    end
    
    methods
        function obj = Rhs(F, varargin)
            if ~isa(F, 'function_handle')
                error('The first argument must be a function');
            end
            
            obj.F = F;
            
            if mod(length(varargin), 2) ~= 0
                error('Uneven number of extra arguments');
            end
            
            for i = 1:2:length(varargin)
                name = varargin{i};
                if ~ischar(name)
                    error('All extra arguments must be name value pairs');
                end
                
                prop = obj.addprop(name);
                obj.(name) = varargin{i + 1};
                prop.SetAccess = 'immutable';
            end
        end
    end
end
