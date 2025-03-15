import 'package:decimal/decimal.dart';

typedef FlourAndGlutenQuantity =
    ({Decimal flourQuantity, Decimal glutenQuantity});

abstract interface class ComputeGlutenAddition {
  FlourAndGlutenQuantity compute({
    required Decimal totalFlour,
    required Decimal flourProteinPercentage,
    required Decimal glutenProteinPercentage,
    required Decimal targetProteinPercentage,
  });
}

final class PriceselyComputeGlutenAddition implements ComputeGlutenAddition {
  factory PriceselyComputeGlutenAddition() =>
      const PriceselyComputeGlutenAddition._();

  const PriceselyComputeGlutenAddition._();

  @override
  FlourAndGlutenQuantity compute({
    required Decimal totalFlour,
    required Decimal flourProteinPercentage,
    required Decimal glutenProteinPercentage,
    required Decimal targetProteinPercentage,
  }) {
    final glutenQuantity = (totalFlour *
            (targetProteinPercentage - flourProteinPercentage) /
            (glutenProteinPercentage - flourProteinPercentage))
        .toDecimal(scaleOnInfinitePrecision: 2);
    final flourQuantity = totalFlour - glutenQuantity;

    return (flourQuantity: flourQuantity, glutenQuantity: glutenQuantity);
  }
}

final class ClassicallyComputeGlutenAddition implements ComputeGlutenAddition {
  factory ClassicallyComputeGlutenAddition() =>
      const ClassicallyComputeGlutenAddition._();

  const ClassicallyComputeGlutenAddition._();

  @override
  FlourAndGlutenQuantity compute({
    required Decimal totalFlour,
    required Decimal flourProteinPercentage,
    required Decimal glutenProteinPercentage,
    required Decimal targetProteinPercentage,
  }) {
    final result = (totalFlour *
            (targetProteinPercentage - flourProteinPercentage) /
            glutenProteinPercentage)
        .toDecimal(scaleOnInfinitePrecision: 2);

    return (flourQuantity: totalFlour - result, glutenQuantity: result);
  }
}
