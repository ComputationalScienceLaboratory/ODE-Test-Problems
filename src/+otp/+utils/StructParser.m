% Consider using validateattributes!!!
classdef (Sealed) StructParser
    
    properties (GetAccess = private, SetAccess = immutable)
        Struct
    end
    
    methods
        function obj = StructParser(s)
            obj.Struct = s;
        end
        
        function obj = checkField(obj, fieldName, varargin)
            if ~isfield(obj.Struct, fieldName)
                error('Missing field %s from struct', fieldName);
            end
            
            fieldVal = obj.Struct.(fieldName);
            
            for i = 1:length(varargin)
                validator = varargin{i};
                
                if ischar(validator)
                    if ~obj.validateFromString(fieldVal, validator)
                        error('The field %s is not %s', fieldName, validator);
                    end
                elseif isa(validator, 'function_handle')
                    if ~validator(fieldVal)
                        error('The field %s does not satisfy %s', fieldName, func2str(validator));
                    end
                else
                    error('Unrecognized validator for field %s', fieldName);
                end
            end
        end
    end
    
    methods (Access = private)
        function isValid = validateFromString(~, x, validator)
            switch validator
                case 'numeric'
                    isValid = isnumeric(x);
                case 'real'
                    isValid = isreal(x);
                case 'finite'
                    isValid = all(isfinite(x), 'all');
                case 'integer'
                    isValid = isreal(x) && all(floor(x) == x, 'all');
                case 'matrix'
                    isValid = ismatrix(x);
                case 'cell'
                    isValid = iscell(x);
                case 'scalar'
                    isValid = isscalar(x);
                case 'positive'
                    isValid = all(x > 0, 'all');
                case 'nonnegative'
                    isValid = all(x >= 0, 'all');
                case 'negative'
                    isValid = all(x < 0, 'all');
                case 'nonpositive'
                    isValid = all(x <= 0, 'all');
                case 'row'
                    isValid = isrow(x);
                case 'column'
                    isValid = iscolumn(x);
                case 'function'
                    isValid = isa(x,'function_handle');
                case 'logical'
                    isValid = islogical(x);
                otherwise
                    error('Unrecognized validator %s', validator);
            end
        end
    end
    
end

