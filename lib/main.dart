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
    mutationRate: 0.3,
  );

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
        child: solution.generations.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridWidget(grid: solution.generations.last.fittest.grid),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      solution.evolutionLoop();
                    }),
                    child: const Text('Evolve'),
                  )
                ],
              ),
      ),
    );
  }
}
