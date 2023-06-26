function J = jacobianForcing(~, x)

numVars = length(x);
J = sparse(numVars, numVars);

end

