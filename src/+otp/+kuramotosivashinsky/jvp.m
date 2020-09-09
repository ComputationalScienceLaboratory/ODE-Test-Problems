function jv = jvp(~, u, k, k2, k4, v)

jv = -k2.*v - k4.*v - k.*fft(real(ifft(u)).*real(ifft(v)));

end
