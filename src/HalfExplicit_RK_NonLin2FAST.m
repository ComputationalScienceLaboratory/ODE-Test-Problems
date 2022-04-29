classdef HalfExplicit_RK_NonLin2FAST
    %HALFEXPLICIT_RK_LIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        a
        ah
        b
        c
        ch
        s
        nmax
        iter_tol
    end
    
    methods
        function obj = HalfExplicit_RK_NonLin2FAST(a, ah, b, c, ch, nm, tol)
            obj.a = a;
            obj.ah = ah;
            obj.b = b;
            obj.c = c;
            obj.ch = ch;
            obj.s = length(a);
            obj.nmax = nm;
            obj.iter_tol = tol;
        end
        
        function [y_f, z_f] = time_step(obj, fx, f_z, g, dt, t, y_0, z_0)
             k = zeros(length(y_0), obj.s);

            %k(:, 1) = f(t,y_0,z_0);
            f_zy_0 = f_z(t,y_0);
            k(:, 1) = fx(t,y_0) - f_zy_0*z_0;
            %iter_jac = (dt * obj.ah(2, 2)) * jac(t, y_0, z_0);

            iter_jac = -(dt * obj.ah(2, 2)) * (f_zy_0.'*f_zy_0);

            %i = 2;

            %while true
            for i = 2:obj.s

                inter_y = y_0;
                inter_y_star = y_0;
                for j = 1:i - 1
                    inter_y = inter_y + dt * obj.a(i, j) * k(:, j);
                    inter_y_star = inter_y_star + dt * obj.ah(i, j)*k(:,j);
                end

                %iter_func = @(x) g(t + dt * obj.ch(i), inter_y_star + dt* obj.ah(i,i) * f(t + dt * obj.c(i), inter_y ,x) );

                fxinter = fx(t + dt * obj.c(i), inter_y);
                f_zinter = f_z(t + dt * obj.c(i), inter_y);
                iter_func = @(x) g(t + dt * obj.ch(i), inter_y_star + dt* obj.ah(i,i) * (fxinter  - f_zinter*x  ) );

                inter_z = obj.chord_iteration(iter_func, iter_jac, z_0);

                k(:, i) = fxinter - f_zinter*inter_z;

                %k(:,i) = f(t + dt * obj.c(i), inter_y, inter_z);

                %if i >= obj.s
                %    break
                %end

                %iter_jac = (dt * obj.ah(i + 1, i + 1)) * jac(t + dt*obj.c(i), inter_y, inter_z);

                %i = i + 1;
            end

            y_f = y_0 + dt*k * obj.b';
            z_f = inter_z;

            %u_f = [;inter_z];
        end

        %Assume jac is precomputed
        function y_f = chord_iteration(obj, func, jac, y_0)
            i = 0;
            iJ = pinv(jac);
            %dJ = decomposition(-jac, 'chol');
            while i < obj.nmax
                x_i = iJ * -func(y_0);
                %x_i = dJ\func(y_0);
                %x_i = jac\-func(y_0);
                y_f = x_i + y_0;

                i = i + 1;
                
                if norm(x_i) < obj.iter_tol
                    return;
                end
                y_0 = y_f;
            end
            

        end
    end
end

