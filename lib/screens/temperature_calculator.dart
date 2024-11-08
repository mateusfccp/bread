import 'package:flutter/material.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

final class TemperatureCalculatorScreen extends StatefulWidget {
  const TemperatureCalculatorScreen({super.key});

  @override
  State<TemperatureCalculatorScreen> createState() => _TemperatureCalculatorScreenState();
}

final class _TemperatureCalculatorScreenState extends State<TemperatureCalculatorScreen> {
  final _targetTemperatureTextController = TextEditingController(text: '25');
  final _airTemperatureTextController = TextEditingController();
  final _flourTemperatureTextController = TextEditingController();
  final _waterTemperatureTextController = TextEditingController();
  late final _temperatureControllers = [
    _airTemperatureTextController,
    _flourTemperatureTextController,
    _waterTemperatureTextController,
  ];

  double? _computedResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _targetTemperatureTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Temperatura alvo'),
                  suffix: Text('°C'),
                ),
                inputFormatters: [_filter],
                keyboardType: _keyboardType,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _airTemperatureTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Temperatura ambiente'),
                  suffix: Text('°C'),
                ),
                inputFormatters: [_filter],
                keyboardType: _keyboardType,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _waterTemperatureTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Temperatura da farinha'),
                  suffix: Text('°C'),
                ),
                inputFormatters: [_filter],
                keyboardType: _keyboardType,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _flourTemperatureTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Temperatura da água'),
                  suffix: Text('°C'),
                ),
                inputFormatters: [_filter],
                keyboardType: _keyboardType,
              ),
              const SizedBox(height: 8.0),
              FilledButton(
                onPressed: _computeValue,
                child: Text('Computar'),
              ),
              if (_computedResult case final result?) ...[
                const SizedBox(height: 8.0),
                Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Adicionar '),
                        TextSpan(
                          text: '${result}g',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' de gluten à farinha.')
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _computeValue() {
    final emptyControllers = _temperatureControllers.where((controller) => controller.text.isEmpty);
    final TextEditingController emptyController;

    try {
      emptyController = emptyControllers.single;
    } catch (error) {
      final text = emptyControllers.isEmpty ? 'Você deve deixar uma das temperaturas vazias!' : 'Apenas uma das temperaturas deve estar vazia!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(text),
          showCloseIcon: true,
        ),
      );

      return;
    }

    final sum = _temperatureControllers //
        .map((controller) => controller.text)
        .map((text) => text.isEmpty ? 0.0 : double.parse(text))
        .reduce((current, next) => current + next);

    final intendedTemperature = double.parse(_targetTemperatureTextController.text);

    final result = intendedTemperature * _temperatureControllers.length - sum;

    // setState(() {
    emptyController.text = result.toString();
    // });
  }
}

const _keyboardType = TextInputType.numberWithOptions(signed: true, decimal: true);
final _filter = NumberTextInputFormatter(decimalDigits: 2);
