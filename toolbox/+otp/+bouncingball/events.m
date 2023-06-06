function [value, isterminal, direction] = events(~, u, ~, ground, ~)

value      = u(2) - ground(u(1));
isterminal = true;
direction  = -1;

end
