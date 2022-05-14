function j = jacobian(t, statepluscontrol, g, m, l, E0)

state   = statepluscontrol(1:4);
control = statepluscontrol(5:end);


dstate = otp.pendulumdae.fDifferential(t, state, g, m, l, E0) ...
    - otp.pendulumdae.jacobianAdjointVectorProductAlgebraic(t, state, control, g, m, l, E0);

c = otp.pendulumdae.fAlgebraic(t, state, g, m, l, E0);


jaccontrol = otp.pendulumdae.jacobianAlgebraic(t, state, g, m, l, E0);

jacstate = otp.pendulumdae.jacobianDifferential(t, state, g, m, l, E0) ...
    - otp.pendulumdae.hessianAdjointVectorProductAlgebraic(t, state, control, eye(4), g, m, l, E0);

jacstatecontrol = -jaccontrol.';


j = [jacstate, jacstatecontrol; jaccontrol, zeros(3, 3)];

end
