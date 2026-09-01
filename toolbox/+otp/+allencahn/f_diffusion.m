% Process splitting: 
%   f = f_diffusion + f_reaction
%   Jacobian = Jacobian_diffusion + Jacobian_reaction
% 
function du = f_diffusion(~, u, L, alpha, ~, ~)

du = alpha*L*u;

end
