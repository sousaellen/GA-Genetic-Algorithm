%% =============== TRABALHO DE INTELIGÊNCIA COMPUTACIONAL =================
%   Instituição:    Universidade Federal do Ceará - UFC, campus Sobral-CE
%   Autor(a):       Raíssa Ellen de Sousa
%   Matrícula:      385135
% =========================================================================
%% DESCRIÇÃO DO PROBLEMA
% Algoritmo genético para achar o máximo da função f(x,y) = |xsen(ypi/4) +
% ysen(xp/4)|. Onde cada indivíduo da população é um vetor binário de 20
% bits,em que os 10 primeiros representam x e os restantes representam y.
% As variáveis x e y pertencem ao intervalo entre 0 e 20.
% O crossover usado é de 1 ponto.

%% CONDIÇÕES INICIAIS

clear all;
close all;
clc;

%% CENÁRIO
% Variáveis x e y dentro do intervalo entre 0 e 20. 
% Gerar todos os valores de x e y possíveis
    y = linspace(0, 20, 1024);
    x = linspace(0, 20, 1024);

% Tratamento dos eixos para serem plotados no plano R3
    [Y,X]= meshgrid(y,x);

% Dado os pontos x e y, calcula-se o valor da função objetivo para tais.
    FO = FuncaoObjetivo(X,Y);

% Plotar o gráfico
    figure('Name','Função Objetivo','NumberTitle','off')
    surf(x,y,FO');
    xlabel('X'); ylabel('Y'); zlabel('FO');
    shading interp;
    
%% VARIÁVEIS
nIndividuos = 500;                  % Número de indivíduos considerados
max_epocas = 100;                   % Número de épocas definido
adeq = 20/1023;                     % Adequando as possibilidades do problema
valormax = 20;                      % Valor máximo que x e y podem assumir
nota_xy = zeros(1,nIndividuos);     % Notas atribuidas ao indivíduo [ x y ]


%% ||||||||||||||||||||||||||||||| GENETIC ALGORITM (GA)|||||||||||||||||||||||||||||||
% Indivíduos iniciais gerados aleatóriamente
individuos = randi([0 1], nIndividuos, valormax );

fprintf('\n\t\t\tGENETIC ALGORITM (GA)\n\n');

for epoca=1:max_epocas
    
    % Conversão dos números binários para decimais
    x = bi2de(individuos(:, (1:10)));   x = adeq.*x;
    y = bi2de(individuos(:, (11:20)));  y = adeq.*y;
    
    % Cálculo das notas de cada indivíduo através da FO
    for i = 1:nIndividuos 
        nota_xy(i) = FuncaoObjetivo(x(i),y(i));
    end
    
    % ROLETA
    
    % Soma das notas obtidas com os indivíduos em questão
    soma_notas = sum(nota_xy);
    
    for j = 1:nIndividuos
        t = 1;
        c = nota_xy(t);         % Maior nota , maior parte na roleta
        s = rand*soma_notas;    % Gira a roleta
        
        while c < s
            t = t + 1;
            c = c + nota_xy(t);
        end
        
        % Seleção dos pais
        individuo_pais(j,:) = individuos(t,:);
    end
    
    % CROSSOVER 
    
    % Geramos os pontos de corte ( Crossover de um ponto )
    pontoCorte = randi([1,19], nIndividuos , 1);
    
    % Geração de filhos com pares dos pais
    for n = 1:2:nIndividuos
        
        % Pais considerados
        pai1 = individuo_pais(n,:);
        pai2 = individuo_pais(n + 1,:);
        
        % Construção dos indivíduos filhos
        % FILHO 1 = Primeira parte do 1° pai / corte / Segunda parte do 2° pai
        individuos(n , :) = [ pai1(:,1:pontoCorte(n)), pai2(:,(pontoCorte(n)+1):20) ];
        % FILHO 2 = Primeira parte do 2° pai / corte / Segunda parte do 1° pai
        individuos(n + 1 , :) = [ pai2(:,1:pontoCorte(n)), pai1(:,(pontoCorte(n)+1):20) ];   

    end
    
    % INFORMAÇÕES
    
    [ valor , indice ] = max(nota_xy);                    % Valor do ponto que máximiza a FO
    resx(epoca) = adeq*bi2de(individuos(indice,1:10));    % Valor de X
    resy(epoca) = adeq*bi2de(individuos(indice,11:20));   % Valor de Y
    text = '\t\tMelhor indivíduo na %d° época:\nx = %f e y = %f\nindivíduo = [%s]\nValor da FO = %f\n\n';
    fprintf(text,epoca, resx(epoca) ,resy(epoca),int2str(individuos(indice,:)),FuncaoObjetivo(resx(epoca),resy(epoca)));
 
end

hold on
% Plota a solução encontrada
plot3(resx(epoca),resy(epoca),FuncaoObjetivo(resx(epoca),resy(epoca)),'k*');

figure('Name','FO x Épocas','NumberTitle','off')
plot(1:max_epocas,FuncaoObjetivo(resx,resy),'r');                     % Plota o valor da FO para cada época
hold on
line(1:max_epocas,ones(1,max_epocas)*(FuncaoObjetivo(18.09,18.09)));  % Melhor valor possível 
legend('Valor alcançado','Valor máximo');                             % com x = 18.09 e y = 18.09
xlabel('Épocas'); ylabel('Valor da FO');
title('Valor alcançado da FO em cada época');

%% Raíssa Ellen de Sousa - 385135















