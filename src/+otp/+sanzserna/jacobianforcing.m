function J = jacobianforcing(~, x)

numVars = length(x);
J = sparse(numVars, numVars);

end

