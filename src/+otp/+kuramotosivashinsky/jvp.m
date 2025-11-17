function jv = jvp(~, u, v, ik, k24)

jv = k24 .* v - ik .* fft(ifft(u) .* ifft(v));

end
