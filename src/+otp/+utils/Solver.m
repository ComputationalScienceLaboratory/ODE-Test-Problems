classdef Solver
    properties (Constant)
        Nonstiff = @ode45
        Stiff = otp.utils.compatibility.isOctave(@ode23s, @ode15s)
        Symplectic = otp.utils.compatibility.isOctave(@ode23s, @ode23t)
    end
    
    methods (Access = private)
        function obj = Solver()
        end
    end
end
