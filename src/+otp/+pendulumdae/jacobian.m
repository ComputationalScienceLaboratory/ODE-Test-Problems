function j = jacobian(t, statepluscontrol, g, m, l, E0)

state   = statepluscontrol(1:4);
control = statepluscontrol(5:end);

jaccontrol = otp.pendulumdae.jacobianAlgebraic(t, state, g, m, l, E0);

jacstate = otp.pendulumdae.jacobianDifferential(t, state, g, m, l, E0) ...
    - otp.pendulumdae.hessianAdjointVectorProductAlgebraic(t, state, control, eye(4), g, m, l, E0);

jacstatecontrol = -jaccontrol.';

j = [jacstate, jacstatecontrol; jaccontrol, zeros(3, 3)];

end
