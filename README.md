# Sensibilidade do MOEA/D a Estratégias de Variação

Este repositório contém uma versão minimalista e customizada da plataforma PlatEMO, configurada exclusivamente para reproduzir os experimentos do estudo **"SENSIBILIDADE DO MOEA/D A ESTRATÉGIAS DE VARIAÇÃO: EFEITOS SOBRE DIVERSIDADE E CONVERGÊNCIA"**.

## Sobre a Pesquisa

O objetivo deste projeto é investigar de forma sistemática a sensibilidade do algoritmo MOEA/D a diferentes operadores de reprodução, sob decomposição de Tchebycheff fixa. O estudo compara o comportamento desses operadores em problemas com Fronteiras de Pareto regulares e irregulares.

## Algoritmos e Operadores Avaliados

O algoritmo base utilizado é o MOEA/D. Foram implementadas e acopladas ao módulo de reprodução as seguintes variantes de operadores:

- ABC (Artificial Bee Colony)
- ACO (Ant Colony Optimization)
- CMA-ES (Covariance Matrix Adaptation Evolution Strategy)
- DE (Differential Evolution)
- EDA (Estimation of Distribution Algorithm)
- MMOPSO (Multiple-Search Multi-objective Particle Swarm Optimization)
- NMS (Nelder-Mead Simplex)
- SA (Simulated Annealing)

## Problemas de Teste e Métricas

Os experimentos foram conduzidos sobre as seguintes instâncias de problemas:

- **Fronteiras Regulares:** DTLZ1 a DTLZ4
- **Fronteiras Irregulares:** DTLZ5 a DTLZ7, IDTLZ1 e IDTLZ2

A avaliação de desempenho (convergência e diversidade) foi realizada utilizando a métrica **IGD (Inverted Generational Distance)**

## Estrutura dos Dados (`/Data`)

A pasta `Data/` contém os arquivos `.mat` com os resultados das 30 execuções independentes realizadas no estudo. Esses dados podem ser carregados diretamente na GUI do PlatEMO para geração de tabelas e aplicação do teste estatístico de Wilcoxon rank-sum

## Como Executar

1. Certifique-se de ter o **MATLAB** instalado (os experimentos originais utilizaram a versão R2026a).
2. Clone este repositório.
3. No terminal do MATLAB, navegue até a raiz do projeto.
4. Digite o comando `platemo` para abrir a interface gráfica ou utilize scripts de automação chamando a classe `ALGORITHM`.
