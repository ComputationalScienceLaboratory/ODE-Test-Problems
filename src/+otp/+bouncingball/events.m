function [value, isterminal, direction] = events(~, u, ~, gF, ~)

value      = u(2) - gF(u(1));
isterminal = true;
direction  = -1;

end
