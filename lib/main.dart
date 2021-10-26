import 'package:flutter/material.dart';
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
  final solution = GeneticAlgorithm(
    maxGenerations: 10000,
    populationSize: 100,
    mutationRate: 0.05,
  );

  var selectedGeneration = 0;
  var isEvolving = false;

  @override
  void initState() {
    solution.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genetic Sudoku'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: solution.generationsLog.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(milliseconds: 50)),
                    builder: (_, __) {
                      if (solution.isFinished()) {
                        setState(() {
                          isEvolving = false;
                        });
                      } else if (isEvolving) {
                        solution.evolutionLoop();
                        selectedGeneration++;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GridWidget(
                              grid: solution
                                  .generationsLog[selectedGeneration].fittest),
                          Text('Current generation: '
                              '${solution.generationsLog[selectedGeneration].generationNumber}'),
                          Text('Current fitness: ' +
                              solution
                                  .generationsLog[selectedGeneration].fitness
                                  .toString()),
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: solution.isFinished()
                        ? null
                        : () => setState(() {
                              isEvolving = !isEvolving;
                              selectedGeneration =
                                  solution.generationsLog.last.generationNumber;
                            }),
                    child: Text(isEvolving ? 'Evolving' : 'Evolve'),
                  )
                ],
              ),
      ),
    );
  }
}
