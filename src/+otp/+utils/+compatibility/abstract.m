function varargout = abstract(varargin)
%ABSTRACT Error to emulate unimplemented abstract method

% OCTAVE FIX: abstract methods are not supported
varargout{1} = 'Abstract method not implemented by subclass';
error('OTP:abstract', varargout{1});

end

