import 'package:flutter/material.dart';
import 'package:genetic_sudoku/models/grid.dart';
import 'package:genetic_sudoku/widgets/grid_widget.dart';
import 'package:genetic_sudoku/algorithm/genetic_algorithm.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Genetic Sudoku',
      home: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final test = GeneticAlgorithm(
      maxGenerations: 10000,
      populationSize: 100,
      mutationRate: 0.3,
    );
    test.initialize();
    print('initial pop size: ${test.generations.last.population.length}');
    while (!test.isFinished()) {
      test.evolutionLoop();
    }
    print('final gen.: ${test.generations.last.generationNumber}');
    print('final fit.: ${test.generations.last.fittest.fitness}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genetic Sudoku'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: GridWidget(grid: Grid()),
      ),
    );
  }
}
