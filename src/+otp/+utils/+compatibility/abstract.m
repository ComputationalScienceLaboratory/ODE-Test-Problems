function varargout = abstract(varargin)
%ABSTRACT Error to emulate unimplemented abstract method

varargout{1} = 'Abstract method not implemented by subclass';
error('OTP:abstract', varargout{1});

end

