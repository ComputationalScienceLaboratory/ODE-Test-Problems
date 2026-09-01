% Process splitting: 
%   f = f_diffusion + f_reaction
%   Jacobian = Jacobian_diffusion + Jacobian_reaction
%
function j = jacobian_diffusion(~, ~, L, alpha, ~, ~)

j = alpha*L;

end
