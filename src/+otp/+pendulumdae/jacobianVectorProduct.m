function dfull = jacobianVectorProduct(t, statepluscontrol, v, g, m, l, E0)

state   = statepluscontrol(1:4, :);
control = statepluscontrol(5:end, :);

vstate = v(1:4, :);
vcontrol = v(5:end, :);

dstate = otp.pendulumdae.jacobianVectorProductDifferential(t, state, vstate, g, m, l, E0) ...
    - otp.pendulumdae.hessianAdjointVectorProductAlgebraic(t, state, control, vstate, g, m, l, E0) ...
    - otp.pendulumdae.jacobianAdjointVectorProductAlgebraic(t, state, vcontrol, g, m, l, E0);

c = otp.pendulumdae.jacobianVectorProductAlgebraic(t, state, vstate, g, m, l, E0);

dfull = [dstate; c];

end
