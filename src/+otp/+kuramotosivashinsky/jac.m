function j = jac(~, u, k, k2, k4, Dfft, Difft)

j = -diag(k2) - diag(k4) - diag(k)*Dfft*diag(ifft(u))*Difft;

end
