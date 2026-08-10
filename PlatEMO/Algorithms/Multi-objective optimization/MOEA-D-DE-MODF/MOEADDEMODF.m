classdef MOEADDEMODF < ALGORITHM
% <2009> <multi/many> <real/integer>
% MOEA/D based on differential evolution

    methods
        function main(Algorithm, Problem)
            [W, Problem.N] = UniformPoint(Problem.N, Problem.M);
            T = ceil(Problem.N / 10);

            B = pdist2(W, W);
            [~, B] = sort(B, 2);
            B = B(:, 1:T);

            Population = Problem.Initialization();
            Z = min(Population.objs, [], 1);

            while Algorithm.NotTerminated(Population)
                for i = 1 : Problem.N
                    P = B(i, randperm(size(B, 2)));

                    OffDec    = OperatorDEOnly(Problem, Population(P));
                    Offspring = OperatorMutationOnly(Problem, OffDec);

                    Z = min(Z, Offspring.obj);

                    g_old = max(abs(Population(P).objs - repmat(Z, T, 1)) .* W(P,:), [], 2);
                    g_new = max(repmat(abs(Offspring.obj - Z), T, 1) .* W(P,:), [], 2);
                    Population(P(g_old >= g_new)) = Offspring;
                end
            end
        end
    end
end