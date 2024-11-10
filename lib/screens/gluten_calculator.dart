import 'package:bread/domain/repositories/gluten_computation_repository.dart';
import 'package:bread/domain/use_cases/compute_gluten_addition.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

final class GlutenCalculatorScreen extends StatefulWidget {
  const GlutenCalculatorScreen({
    super.key,
    required this.glutenComputationRepository,
  });

  final GlutenComputationRepository glutenComputationRepository;

  @override
  State<GlutenCalculatorScreen> createState() => _GlutenCalculatorScreenState();
}

final class _GlutenCalculatorScreenState extends State<GlutenCalculatorScreen> {
  late final _flourQuantityTextController = TextEditingController(text: widget.glutenComputationRepository.flourQuantity.toString());
  late final _flourProteinPercentageTextController = TextEditingController(text: widget.glutenComputationRepository.flourProteinPercentage.toString());
  late final _targetProteinPercentageTextController = TextEditingController(text: widget.glutenComputationRepository.targetProteinPercentage.toString());
  late final _glutenProteinPercentageTextController = TextEditingController(text: widget.glutenComputationRepository.glutenProteinPercentage.toString());

  Decimal? _flourQuantity;
  Decimal? _computedResult;

  @override
  void initState() {
    super.initState();

    _flourQuantityTextController.addListener(_setFlourQuantity);
    _flourProteinPercentageTextController.addListener(_setFlourProteinPercentage);
    _targetProteinPercentageTextController.addListener(_setTargetProteinPercentage);
    _glutenProteinPercentageTextController.addListener(_setGlutenProteinPercentage);
  }

  @override
  void dispose() {
    _glutenProteinPercentageTextController.removeListener(_setGlutenProteinPercentage);
    _targetProteinPercentageTextController.removeListener(_setTargetProteinPercentage);
    _flourProteinPercentageTextController.removeListener(_setFlourProteinPercentage);
    _flourQuantityTextController.removeListener(_setFlourQuantity);
    _glutenProteinPercentageTextController.dispose();
    _targetProteinPercentageTextController.dispose();
    _flourProteinPercentageTextController.dispose();
    _flourQuantityTextController.dispose();
    super.dispose();
  }

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
                controller: _flourQuantityTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Quantidade de farinha'),
                  suffix: Text('g'),
                ),
                inputFormatters: [_filter],
                keyboardType: _keyboardType,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _flourProteinPercentageTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Percentual de proteína da farinha'),
                  suffix: Text('%'),
                ),
                inputFormatters: [_filter],
                keyboardType: _keyboardType,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _targetProteinPercentageTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Percentual alvo'),
                  suffix: Text('%'),
                ),
                inputFormatters: [_filter],
                keyboardType: _keyboardType,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _glutenProteinPercentageTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Percentual de proteína do gluten'),
                  suffix: Text('%'),
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
                  child: Column(
                    children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Quantidade de farinha: '),
                              TextSpan(
                                text: '${_flourQuantity!}g',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Quantidade de glúten: '),
                            TextSpan(
                              text: '${result}g',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _setFlourQuantity() {
    final decimal = Decimal.tryParse(_flourQuantityTextController.text);

    if (decimal != null) {
      widget.glutenComputationRepository.flourQuantity = decimal;
      _flourQuantity = decimal;
    }
  }

  void _setFlourProteinPercentage() {
    final decimal = Decimal.tryParse(_flourProteinPercentageTextController.text);

    if (decimal != null) {
      widget.glutenComputationRepository.flourProteinPercentage = decimal;
    }
  }

  void _setTargetProteinPercentage() {
    final decimal = Decimal.tryParse(_targetProteinPercentageTextController.text);

    if (decimal != null) {
      widget.glutenComputationRepository.targetProteinPercentage = decimal;
    }
  }

  void _setGlutenProteinPercentage() {
    final decimal = Decimal.tryParse(_glutenProteinPercentageTextController.text);

    if (decimal != null) {
      widget.glutenComputationRepository.glutenProteinPercentage = decimal;
    }
  }

  void _computeValue() {
    final hundred = Decimal.fromInt(100);
    final totalFlour = Decimal.parse(_flourQuantityTextController.text);
    final flourProteinPercentage = Decimal.parse(_flourProteinPercentageTextController.text) / hundred;
    final targetProteinPercentage = Decimal.parse(_targetProteinPercentageTextController.text) / hundred;
    final glutenProteinPercentage = Decimal.parse(_glutenProteinPercentageTextController.text) / hundred;

    final algorithm = PriceselyComputeGlutenAddition();

    setState(() {
      final Decimal flourQuantity, glutenQuantity;
      
      (:flourQuantity, :glutenQuantity) = algorithm.compute(
        totalFlour: totalFlour,
        flourProteinPercentage: flourProteinPercentage.toDecimal(scaleOnInfinitePrecision: 2),
        glutenProteinPercentage: glutenProteinPercentage.toDecimal(scaleOnInfinitePrecision: 2),
        targetProteinPercentage: targetProteinPercentage.toDecimal(scaleOnInfinitePrecision: 2),
      );
      
      _flourQuantity = flourQuantity;
      _computedResult = glutenQuantity;
    });
  }
}

const _keyboardType = TextInputType.numberWithOptions(signed: true, decimal: true);
final _filter = NumberTextInputFormatter(decimalDigits: 2);
