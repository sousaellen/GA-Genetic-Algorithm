    
%% FUN��O OBJETIVO

%   A fun��o objetivo � descrita por 
%   f(x,y) = |xsen(ypi/4) + ysen(xpi/4)|

function [ FO ] = FuncaoObjetivo( x , y )
 FO = abs( x.*sin(y.*pi/4) + y.*sin(x.*pi/4));
end
