classdef MOEADSA < ALGORITHM
% <2007> <multi/many> <real/integer/label/binary/permutation>
% Multiobjective evolutionary algorithm based on decomposition
% type --- 1 --- The type of aggregation function

%------------------------------- Reference --------------------------------
% Q. Zhang and H. Li. MOEA/D: A multiobjective evolutionary algorithm based
% on decomposition. IEEE Transactions on Evolutionary Computation, 2007,
% 11(6): 712-731.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2026 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm, Problem)
            %% Geração dos vetores de peso
            [W, Problem.N] = UniformPoint(Problem.N, Problem.M);
            T = ceil(Problem.N / 10);

            %% Vizinhança de cada subproblema
            B = pdist2(W, W);
            [~, B] = sort(B, 2);
            B = B(:, 1:T);

            %% População inicial
            Population = Problem.Initialization();
            Z = min(Population.objs, [], 1);

            %% Loop principal
            while Algorithm.NotTerminated(Population)
                for i = 1 : Problem.N
                    % Seleciona vizinhos aleatoriamente
                    P = B(i, randperm(size(B, 2)));

                    OffDec = OperatorABCOnly(Problem, Population(P));

                    % Mutação polinomial + avaliação
                    Offspring = OperatorMutationOnly(Problem, OffDec);

                    % Atualiza ponto ideal
                    Z = min(Z, Offspring.obj);

                    % Atualiza vizinhos via Tchebycheff
                    g_old = max(abs(Population(P).objs - repmat(Z, T, 1)) .* W(P, :), [], 2);
                    g_new = max(repmat(abs(Offspring.obj - Z), T, 1) .* W(P, :), [], 2);
                    Population(P(g_old >= g_new)) = Offspring;
                end
            end
        end
    end
end