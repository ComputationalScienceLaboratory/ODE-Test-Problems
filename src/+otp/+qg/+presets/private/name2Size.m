function [nx, ny] = name2Size(name)

switch name
    case 'atomic'
        nx = 3;
    case 'miniscule'
        nx = 7;
    case 'tiny'
        nx = 15;
    case 'small'
        nx = 31;
    case 'medium'
        nx = 63;
    case 'large'
        nx = 127;
    case 'huge'
        nx = 255;
    case 'monsterous'
        nx = 511;
    case 'bigly'
        nx = 1023;
    otherwise
        error('Cannot convert string to grid sizes');
end

ny = 2*nx + 1;
    
end
