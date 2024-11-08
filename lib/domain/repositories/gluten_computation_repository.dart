import 'package:decimal/decimal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class GlutenComputationRepository {
  /// The amount of flour used.
  abstract Decimal flourQuantity;

  /// The protein percentage that the flour has.
  abstract Decimal flourProteinPercentage;

  /// The protein percentage that the flour should have.
  abstract Decimal targetProteinPercentage;

  /// The percentage of protein of the added gluten.
  abstract Decimal glutenProteinPercentage;

  /// Whether the flour should be subtracted proportionally to the added gluten.
  abstract bool subtractGlutenFromTotalFlour;
}

final class DefaultGlutenComputationRepository implements GlutenComputationRepository {
  DefaultGlutenComputationRepository({
    required this.sharedPreferences,
  });

  final SharedPreferencesWithCache sharedPreferences;

  @override
  Decimal get flourQuantity {
    final flourQuantityString = sharedPreferences.getString('flourQuantity');

    if (flourQuantityString == null) {
      final defaultFlourQuantity = Decimal.fromInt(400);
      flourQuantity = defaultFlourQuantity;
      return defaultFlourQuantity;
    } else {
      return Decimal.parse(flourQuantityString);
    }
  }

  @override
  set flourQuantity(Decimal value) {
    sharedPreferences.setString('flourQuantity', value.toString());
  }

  @override
  Decimal get flourProteinPercentage {
    final flourProteinPercentageString = sharedPreferences.getString('flourProteinPercentage');

    if (flourProteinPercentageString == null) {
      final defaultFlourProteinPercentage = Decimal.fromInt(9);
      flourProteinPercentage = defaultFlourProteinPercentage;
      return defaultFlourProteinPercentage;
    } else {
      return Decimal.parse(flourProteinPercentageString);
    }
  }

  @override
  set flourProteinPercentage(Decimal value) {
    sharedPreferences.setString('flourProteinPercentage', value.toString());
  }

  @override
  Decimal get targetProteinPercentage {
    final targetProteinPercentageString = sharedPreferences.getString('targetProteinPercentage');

    if (targetProteinPercentageString == null) {
      final defaultTargetProteinPercentage = Decimal.fromInt(13);
      targetProteinPercentage = defaultTargetProteinPercentage;
      return defaultTargetProteinPercentage;
    } else {
      return Decimal.parse(targetProteinPercentageString);
    }
  }

  @override
  set targetProteinPercentage(Decimal value) {
    sharedPreferences.setString('targetProteinPercentage', value.toString());
  }

  @override
  Decimal get glutenProteinPercentage {
    final glutenProteinPercentageString = sharedPreferences.getString('glutenProteinPercentage');

    if (glutenProteinPercentageString == null) {
      final defaultGlutenProteinPercentage = Decimal.fromInt(75);
      glutenProteinPercentage = defaultGlutenProteinPercentage;
      return defaultGlutenProteinPercentage;
    } else {
      return Decimal.parse(glutenProteinPercentageString);
    }
  }

  @override
  set glutenProteinPercentage(Decimal value) {
    sharedPreferences.setString('glutenProteinPercentage', value.toString());
  }

  @override
  bool get subtractGlutenFromTotalFlour {
    final subtractFlutenFromTotalFlour = sharedPreferences.getBool('subtractGlutenFromTotalFlour');

    if (subtractFlutenFromTotalFlour == null) {
      final defaultSubtractFlutenFromTotalFlour = true;
      subtractGlutenFromTotalFlour = defaultSubtractFlutenFromTotalFlour;
      return defaultSubtractFlutenFromTotalFlour;
    } else {
      return subtractFlutenFromTotalFlour;
    }
  }

  @override
  set subtractGlutenFromTotalFlour(bool value) {
    sharedPreferences.setBool('subtractGlutenFromTotalFlour', value);
  }
}
