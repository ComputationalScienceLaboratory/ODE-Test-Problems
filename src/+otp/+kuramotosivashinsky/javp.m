function jv = javp(~, u, k, k2, k4, v)

jv = -k2.*v - k4.*v - fft(real(ifft(u)).*ifft(conj(k).*v));

end
