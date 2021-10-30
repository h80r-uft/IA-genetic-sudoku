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
  /// Instância do algoritmo genético
  ///
  /// Configurada para executar até `100.000` gerações com uma população de
  /// `100` cromossomos (sudokus), e uma taxa de mutação de `0.025`, ou seja,
  /// `2.5%`. Utilizando um sudoku difícil, gerado pelo site
  /// [sudoku.com](https://sudoku.com/pt/dificil/).
  ///
  /// A execução será encerrada antes de 100.000 gerações caso o sudoku seja
  /// resolvido pelo algoritmo.
  final solution = GeneticAlgorithm(
    maxGenerations: 1000000,
    populationSize: 50,
    mutationRate: 0.2,
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
    ].map((e) => Cell(value: e[0], cellNumber: e[1], isFixed: true)).toList(),
  );

  /// O número da geração atualmente exibida na tela.
  var selectedGeneration = 0;

  /// Indica se o usuário ativou a evolução do algoritmo.
  var isEvolving = false;

  @override
  void initState() {
    solution.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final smallestSize = width < height ? width : height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Genetic Sudoku'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Center(
        child: solution.generationsLog.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(milliseconds: 1)),
                    builder: (_, __) {
                      if (solution.isFinished()) {
                        isEvolving = false;
                      } else if (isEvolving) {
                        solution.evolutionLoop();
                        selectedGeneration++;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: SizedBox(
                              width: smallestSize * 0.65,
                              height: smallestSize * 0.65,
                              child: Center(
                                child: GridWidget(
                                    grid: solution
                                        .generationsLog[selectedGeneration]
                                        .fittest),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: smallestSize * 0.020,
                          ),
                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: SizedBox(
                              height: smallestSize * 0.20,
                              width: width * 0.65,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Current generation: '
                                      '${solution.generationsLog[selectedGeneration].generationNumber}'),
                                  Text('Current fitness: ' +
                                      solution
                                          .generationsLog[selectedGeneration]
                                          .fitness
                                          .toString()),
                                  Slider(
                                    min: 0,
                                    max: solution.generationsLog.length - 1,
                                    value: selectedGeneration.toDouble(),
                                    label: solution
                                        .generationsLog[selectedGeneration]
                                        .generationNumber
                                        .toString(),
                                    onChanged: isEvolving
                                        ? null
                                        : (selection) {
                                            setState(() {
                                              selectedGeneration =
                                                  selection.round();
                                            });
                                          },
                                    activeColor: primaryColor,
                                    thumbColor: primaryColor,
                                    inactiveColor: secondaryColor,
                                  ),
                                  ElevatedButton(
                                    onPressed: solution.isFinished()
                                        ? null
                                        : () => setState(() {
                                              isEvolving = !isEvolving;
                                              selectedGeneration = solution
                                                  .generationsLog
                                                  .last
                                                  .generationNumber;
                                            }),
                                    child: Text(
                                        isEvolving ? 'Evolving' : 'Evolve'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
