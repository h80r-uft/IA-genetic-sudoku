import 'package:flutter/material.dart';
import 'package:genetic_sudoku/models/cell.dart';
import 'package:genetic_sudoku/theme/schema_colors.dart';
import 'package:genetic_sudoku/widgets/grid_widget.dart';
import 'package:genetic_sudoku/algorithm/genetic_algorithm.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Genetic Sudoku',
      home: GeneticSudoku(),
    );
  }
}

class GeneticSudoku extends StatefulWidget {
  const GeneticSudoku({Key? key}) : super(key: key);

  @override
  State<GeneticSudoku> createState() => _GeneticSudokuState();
}

class _GeneticSudokuState extends State<GeneticSudoku> {
  /// Lista de instâncias do algoritmo genético.
  final alternatives = List.generate(
      100,
      (index) => GeneticAlgorithm(
          maxGenerations: 1000,
          populationSize: 100,
          mutationRate: 0.2,
          reproductionRate: 0.4,
          fixedCells: [
            [7, 1],
            [2, 4],
            [1, 6],
            [6, 9],
            [3, 11],
            [2, 18],
            [3, 21],
            [5, 24],
            [3, 31],
            [6, 34],
            [6, 37],
            [4, 38],
            [7, 39],
            [8, 43],
            [5, 46],
            [9, 49],
            [4, 52],
            [4, 55],
            [7, 58],
            [9, 60],
            [2, 64],
            [8, 68],
            [5, 70],
          ]
              .map((e) => Cell(value: e[0], cellNumber: e[1], isFixed: true))
              .toList()));

  @override
  void initState() {
    for (final solution in alternatives) {
      solution.initialize();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genetic Sudoku'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder(
              stream: Stream.periodic(const Duration(milliseconds: 50)),
              builder: (_, __) {
                for (final solution in alternatives) {
                  if (!solution.isFinished()) {
                    solution.evolutionLoop();
                  }
                }

                final sortedAlgorithms = alternatives
                  ..sort((a, b) => a.generationsLog.last.fitness
                      .compareTo(b.generationsLog.last.fitness));

                final solution = sortedAlgorithms.first;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridWidget(grid: solution.generationsLog.last.fittest),
                    Text('Current generation: '
                        '${solution.generationsLog.last.generationNumber}'),
                    Text('Current fitness: ' +
                        solution.generationsLog.last.fitness.toString()),
                    Text('Mutation rate: ' + solution.mutationRate.toString()),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) {
                  final worstAlternative = alternatives.reduce(
                    (a, b) => a.generationsLog.last.fitness >
                            b.generationsLog.last.fitness
                        ? a
                        : b,
                  );
                  final bestAlternative = alternatives.reduce(
                    (a, b) => a.generationsLog.last.fitness <
                            b.generationsLog.last.fitness
                        ? a
                        : b,
                  );
                  final sum = alternatives.fold(
                    {'generations': 0, 'fitness': 0},
                    (Map<String, int> acc, cur) => {
                      'generations':
                          acc['generations']! + cur.generationsLog.length,
                      'fitness':
                          acc['fitness']! + cur.generationsLog.last.fitness
                    },
                  );

                  return SimpleDialog(
                    title: const Text('Resultados alcançados'),
                    children: [
                      Text('Melhor iteração: ' +
                          bestAlternative.generationsLog.last.fitness
                              .toString()),
                      Text('Gerações desta iteração: ' +
                          bestAlternative.generationsLog.length.toString()),
                      Text('Pior iteração: ' +
                          worstAlternative.generationsLog.last.fitness
                              .toString()),
                      Text('Gerações desta iteração: ' +
                          worstAlternative.generationsLog.length.toString()),
                      Text('Média de gerações: ' +
                          (sum['generations']! / alternatives.length)
                              .toString()),
                      Text('Média de fitness: ' +
                          (sum['fitness']! / alternatives.length).toString()),
                    ],
                  );
                },
              ),
              child: const Text('Exibir resultados'),
            ),
          ],
        ),
      ),
    );
  }
}
