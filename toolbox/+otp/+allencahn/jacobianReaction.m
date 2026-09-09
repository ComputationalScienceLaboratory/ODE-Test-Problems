% Process splitting: 
%   f = f_diffusion + f_reaction
%   Jacobian = Jacobian_diffusion + Jacobian_reaction
% 
function j = jacobianReaction(~, u, L, ~, beta, ~)

j = spdiags(beta*(1 - 3*u.^2), 0, size(L, 1), size(L, 2));

end
