% Process splitting: 
%   f = f_diffusion + f_reaction
%   Jacobian = Jacobian_diffusion + Jacobian_reaction
%
function j = jacobianDiffusion(~, ~, L, alpha, ~, ~)

j = alpha*L;

end
