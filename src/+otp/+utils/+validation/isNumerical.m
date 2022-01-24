function result = isNumerical(x)

result = isnumeric(x) || isa(x, 'sym');

end
