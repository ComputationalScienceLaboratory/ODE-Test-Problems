classdef Rhs < dynamicprops
    properties (SetAccess = immutable)
        F
    end
    
    properties (Constant, Hidden)
        FieldNames = struct( ...
            ... % odeset fields
            'NonNegative',                  'NonNegative', ...
            'Jacobian',                     'Jacobian', ...
            'JPattern',                     'JPattern', ...
            'Vectorized',                   'Vectorized', ...
            'Mass',                         'Mass', ...
            'MStateDependence',             'MStateDependence', ...
            'MvPattern',                    'MvPattern', ...
            'MassSingular',                 'MassSingular', ...
            'Events',                       'Events', ...
            ... % other fields
            'JacobianVectorProduct',        'JacobianVectorProduct', ...
            'JacobianAdjointVectorProduct', 'JacobianAdjointVectorProduct', ...
            'PartialDerivativeParameters',  'PartialDerivativeParameters', ...
            'PartialDerivativeTime',        'PartialDerivativeTime', ...
            'HessianVectorProduct',         'HessianVectorProduct', ...
            'HessianAdjointVectorProduct',  'HessianAdjointVectorProduct', ...
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
                prop.SetAccess = 'private';
            end
        end
        
        function s = struct(obj)
            props = properties(obj);
            s = struct();
            for i = 1:length(props)
                s.(props{i}) = obj.(props{i});
            end
        end
        
        function opts = odeset(obj, varargin)
            opts = odeset(struct(obj), varargin{:});
        end
    end
end
