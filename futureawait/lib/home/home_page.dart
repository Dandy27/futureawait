import 'dart:async';

import 'package:flutter/material.dart';
import 'package:futureawait/repository/buscas_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = '';
  String _chronometerText = '00:00:00';
  final _chrnometer = Stopwatch();
  late Timer timer;

  void _startChronometer() {
    timer = Timer.periodic(Duration(seconds: 1), _updateTime);
  }

  void _updateTime(_) {
    if (!_chrnometer.isRunning) {
      timer.cancel();
    }
    setState(() {
      _updateChronometerText();
    });
  }

  void _updateChronometerText() {
    final _chronometerElapsed = _chrnometer.elapsed;
    final hours = _chronometerElapsed.inHours.toString().padLeft(2, '0');
    final minutes =
        (_chronometerElapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds =
        (_chronometerElapsed.inSeconds % 60).toString().padLeft(2, '0');
    _chronometerText = '$hours: $minutes : $seconds';
  }

  Future<void> loadPageAsyncAwaint() async {
    final repository = BuscasRepository();

    setState(() {
      _message = 'Iniciando consulta';
    });

    _chrnometer.reset();
    _startChronometer();

    _chrnometer.start();

    final busca1 = await repository.buscarDados1();
    final busca2 = await repository.buscarDados2();
    final busca3 = await repository.buscarDados3();
    _chrnometer.stop();
    setState(() {
      _message = 'Consulta finalizada';
    });
  }

  Future<void> loadPageAsync() async {
    final repository = BuscasRepository();

    setState(() {
      _message = 'Iniciando consulta';
    });

    _chrnometer.reset();
    _startChronometer();

    _chrnometer.start();

    final busca1 = repository.buscarDados1();
    final busca2 = repository.buscarDados2();
    final busca3 = repository.buscarDados3();

    final resultArray = await Future.wait([busca1, busca2, busca3]);
    print(resultArray);

    _chrnometer.stop();
    setState(() {
      _message = 'Consulta finalizada';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => loadPageAsyncAwaint(),
                child: const Text('Iniciar Consulta Async Await'),
              ),
              ElevatedButton(
                onPressed: () => loadPageAsync(),
                child: const Text('Iniciar Consulta Async '),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Text(
                  _chronometerText,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(_message)
            ],
          ),
        ));
  }
}
