function jac = jacobianLinear(~, b)

jac = [-1 - b, 0; b, 0];

end
