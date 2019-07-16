%% =============== TRABALHO DE INTELIG�NCIA COMPUTACIONAL =================

%   Institui��o:    Universidade Federal do Cear� - UFC, campus Sobral-CE
%   Autor(a):       Ra�ssa Ellen de Sousa
%   Matr�cula:      385135

% =========================================================================

%% DESCRI��O DO PROBLEMA

% Algoritmo gen�tico para achar o m�ximo da fun��o f(x,y) = |xsen(ypi/4) +
% ysen(xp/4)|. Onde cada indiv�duo da popula��o � um vetor bin�rio de 20
% bits,em que os 10 primeiros representam x e os restantes representam y.
% As vari�veis x e y pertencem ao intervalo entre 0 e 20.

% O crossover usado � de 1 ponto.


%% CONDI��ES INICIAIS

clear all;
close all;
clc;

%% CEN�RIO

% Vari�veis x e y dentro do intervalo entre 0 e 20. 
% Gerar todos os valores de x e y poss�veis
    y = linspace(0, 20, 1024);
    x = linspace(0, 20, 1024);

% Tratamento dos eixos para serem plotados no plano R3
    [Y,X]= meshgrid(y,x);

% Dado os pontos x e y, calcula-se o valor da fun��o objetivo para tais.
    FO = FuncaoObjetivo(X,Y);

% Plotar o gr�fico
    figure('Name','Fun��o Objetivo','NumberTitle','off')
    surf(x,y,FO');
    xlabel('X'); ylabel('Y'); zlabel('FO');
    shading interp;
    
%% VARI�VEIS

nIndividuos = 500;                  % N�mero de indiv�duos considerados
max_epocas = 100;                   % N�mero de �pocas definido
adeq = 20/1023;                     % Adequando as possibilidades do problema
valormax = 20;                      % Valor m�ximo que x e y podem assumir
nota_xy = zeros(1,nIndividuos);     % Notas atribuidas ao indiv�duo [ x y ]


%% ||||||||||||||||||||||||||||||| GENETIC ALGORITM (GA)|||||||||||||||||||||||||||||||

% Indiv�duos iniciais gerados aleat�riamente
individuos = randi([0 1], nIndividuos, valormax );

fprintf('\n\t\t\tGENETIC ALGORITM (GA)\n\n');

for epoca=1:max_epocas
    
    % Convers�o dos n�meros bin�rios para decimais
    x = bi2de(individuos(:, (1:10)));   x = adeq.*x;
    y = bi2de(individuos(:, (11:20)));  y = adeq.*y;
    
    % C�lculo das notas de cada indiv�duo atrav�s da FO
    for i = 1:nIndividuos 
        nota_xy(i) = FuncaoObjetivo(x(i),y(i));
    end
    
    % ROLETA
    
    % Soma das notas obtidas com os indiv�duos em quest�o
    soma_notas = sum(nota_xy);
    
    for j = 1:nIndividuos
        t = 1;
        c = nota_xy(t);         % Maior nota , maior parte na roleta
        s = rand*soma_notas;    % Gira a roleta
        
        while c < s
            t = t + 1;
            c = c + nota_xy(t);
        end
        
        % Sele��o dos pais
        individuo_pais(j,:) = individuos(t,:);
    end
    
    % CROSSOVER 
    
    % Geramos os pontos de corte ( Crossover de um ponto )
    pontoCorte = randi([1,19], nIndividuos , 1);
    
    % Gera��o de filhos com pares dos pais
    for n = 1:2:nIndividuos
        
        % Pais considerados
        pai1 = individuo_pais(n,:);
        pai2 = individuo_pais(n + 1,:);
        
        % Constru��o dos indiv�duos filhos
        % FILHO 1 = Primeira parte do 1� pai / corte / Segunda parte do 2� pai
        individuos(n , :) = [ pai1(:,1:pontoCorte(n)), pai2(:,(pontoCorte(n)+1):20) ];
        % FILHO 2 = Primeira parte do 2� pai / corte / Segunda parte do 1� pai
        individuos(n + 1 , :) = [ pai2(:,1:pontoCorte(n)), pai1(:,(pontoCorte(n)+1):20) ];   

    end
    
    % INFORMA��ES
    
    [ valor , indice ] = max(nota_xy);                    % Valor do ponto que m�ximiza a FO
    resx(epoca) = adeq*bi2de(individuos(indice,1:10));    % Valor de X
    resy(epoca) = adeq*bi2de(individuos(indice,11:20));   % Valor de Y
    text = '\t\tMelhor indiv�duo na %d� �poca:\nx = %f e y = %f\nindiv�duo = [%s]\nValor da FO = %f\n\n';
    fprintf(text,epoca, resx(epoca) ,resy(epoca),int2str(individuos(indice,:)),FuncaoObjetivo(resx(epoca),resy(epoca)));
 
end

hold on
% Plota a solu��o encontrada
plot3(resx(epoca),resy(epoca),FuncaoObjetivo(resx(epoca),resy(epoca)),'k*');

figure('Name','FO x �pocas','NumberTitle','off')
plot(1:max_epocas,FuncaoObjetivo(resx,resy),'r');                     % Plota o valor da FO para cada �poca
hold on
line(1:max_epocas,ones(1,max_epocas)*(FuncaoObjetivo(18.09,18.09)));  % Melhor valor poss�vel 
legend('Valor alcan�ado','Valor m�ximo');                             % com x = 18.09 e y = 18.09
xlabel('�pocas'); ylabel('Valor da FO');
title('Valor alcan�ado da FO em cada �poca');

%% Ra�ssa Ellen de Sousa - 385135
















