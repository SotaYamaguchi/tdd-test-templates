class PurchaseDate {
  final DateTime _value;
  PurchaseDate._(this._value);

  DateTime get value => _value;

  factory PurchaseDate.fromValue(DateTime value) {
    return PurchaseDate._(value);
  }

  bool isMonday() {
    return _value.weekday == DateTime.monday;
  }

  bool is10th() {
    return _value.day == 10;
  }
}

class PurchaseAmount {
  final int _value;
  PurchaseAmount._(this._value);

  int get value => _value;

  factory PurchaseAmount.fromValue(int value) {
    return PurchaseAmount._(value);
  }

  bool isAtLeast5000Yen() {
    return _value >= 5000;
  }
}

class Point {
  final int _value;
  Point._(this._value);

  int get value => _value;

  factory Point.fromValue(int value) {
    return Point._(value);
  }

  factory Point.fromPurchaseAmount(PurchaseAmount amount) {
    // 購入額の1%をポイントとして付与
    return Point._((amount.value * 0.01).floor());
  }

  Point doublePoints() {
    return Point._(_value * 2);
  }

  Point add(Point target) {
    return Point._(_value + target.value);
  }
}

class CalculateMemberPoints {
  static Point calculate(
      PurchaseDate purchaseDate, PurchaseAmount purchaseAmount,
      {bool isAge65OrOlder = false}) {
    Point point = Point.fromPurchaseAmount(purchaseAmount);
    if (point.value <= 0) {
      return Point.fromValue(0);
    }

    if (purchaseDate.isMonday() || purchaseAmount.isAtLeast5000Yen()) {
      point = point.doublePoints();
    }

    // シルバーデイ
    if (purchaseDate.is10th() && isAge65OrOlder) {
      point = point.add(Point.fromValue(10));
    }

    return point;
  }
}
