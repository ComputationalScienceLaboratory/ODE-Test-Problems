function jv = javp(~, u, v, ik, k24)

jv = k24 .* v + fft(conj(ifft(u)) .* ifft(ik .* v));

end
