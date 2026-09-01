% Process splitting: 
%   f = f_diffusion + f_reaction
%   Jacobian = Jacobian_diffusion + Jacobian_reaction
% 
function du = f_reaction(t, u, ~, ~, beta, forcing)

du = beta * (u - u.^3) + forcing(t);

end
