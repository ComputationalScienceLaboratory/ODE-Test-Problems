classdef NRHO < otp.cr3bp.CR3BPProblem
    % This preset builds an $L_2$ halo orbit preset for the CR3BP based on
    % a table of reference initial conditions and periods. The table
    % contains $20$ entries, and thus there are $20$ different possible
    % orbits given by this preset. The table of $L_2$ halo orbits is given 
    % as Table A.1 on page 218 of :cite:p:`Spr21`.

    methods
        function obj = NRHO(varargin)
            % Create the NRHO CR3BP problem object.
            %
            % Parameters
            % ----------
            % Index : numeric(1, 1)
            %    An integer index between 1 and 20.

            T = getL2halotable();

            p = inputParser();
            p.addParameter('Index', 1, @(x) mod(x, 1) == 0 & x > 0 & x <= size(T, 1));
            p.parse(varargin{:});
            results = p.Results;

            pic = T(results.Index, :);
            
            orbitalperiod = pic(1);
            ic = pic(2:end);

            mE = otp.utils.PhysicalConstants.EarthMass;
            mL = otp.utils.PhysicalConstants.MoonMass;
            G  = otp.utils.PhysicalConstants.GravitationalConstant;

            % derive mu
            muE = G*mE;
            muL = G*mL;
            mu = muL/(muE + muL);

            y0    = [ic(1); 0; ic(2); 0; ic(3); 0];
            tspan = [0, orbitalperiod];
            params = otp.cr3bp.CR3BPParameters('Mu', mu, 'SoftFactor', 0);
            obj = obj@otp.cr3bp.CR3BPProblem(tspan, y0, params);            
        end
    end
end


function T = getL2halotable()
% create internal table of L_2 Halo orbits
% see 
T = [ ...
    1.3632096570 1.0110350588 -0.1731500000 -0.0780141199; ...
    1.4748399512 1.0192741002 -0.1801324242 -0.0971927950; ...
    1.5872714606 1.0277926091 -0.1858044184 -0.1154896637; ...
    1.7008482705 1.0362652156 -0.1904417454 -0.1322667493; ...
    1.8155211042 1.0445681848 -0.1942338538 -0.1473971442; ...
    1.9311168544 1.0526805665 -0.1972878310 -0.1609628828; ...
    2.0474562565 1.0606277874 -0.1996480091 -0.1731020372; ...
    2.1741533495 1.0691059976 -0.2014140887 -0.1847950147; ...
    2.2915829886 1.0768767277 -0.2022559057 -0.1943508955; ...
    2.4093619266 1.0846726654 -0.2022295078 -0.2027817501; ...
    2.5273849254 1.0925906981 -0.2011567058 -0.2101017213; ...
    2.6455248145 1.1007585320 -0.1987609769 -0.2162644440; ...
    2.7635889805 1.1093498794 -0.1946155759 -0.2211327592; ...
    2.8909903824 1.1194130163 -0.1873686594 -0.2246002627; ...
    3.0073088423 1.1297344316 -0.1769810336 -0.2254855800; ...
    3.1205655022 1.1413664663 -0.1612996515 -0.2229158600; ...
    3.2266000495 1.1542349115 -0.1379744940 -0.2147411949; ...
    3.3173903769 1.1669663066 -0.1049833863 -0.1984458292; ...
    3.3833013605 1.1766385512 -0.0621463948 -0.1748356762; ...
    3.4154433338 1.1808881373 -0.0032736457 -0.1559184478];
end
