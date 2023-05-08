classdef Solver
    properties (Constant)
        Nonstiff = @ode45        
        Stiff = otp.utils.compatibility.isOctave(@ode23s, @ode15s) % OCTAVE FIX: ode15s does not
        % support the odeset property Vectorized, struggles with step size control, and transposes
        % solution output compared to other solvers
        StiffNonConstantMass = @ode15s % OCTAVE FIX: need this special case because the default
        % stiff method does not support time or state dependent mass matrices
        Symplectic = otp.utils.compatibility.isOctave(@ode23s, @ode23t) % OCTAVE FIX: ode23t is not
        % available
    end
    
    methods (Access = private)
        function obj = Solver()
        end
    end
end
