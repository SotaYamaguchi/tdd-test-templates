import 'package:flutter_test/flutter_test.dart';
import 'package:dart_flutter/sample/calculate_member_points.dart';

void main() {
  group('CalculateMemberPoints', () {
    /*
     *
     * このシステムでは、渡した日付と購入金額、購入者の年齢に応じてポイントを計算して返す
     *
     * 仕様
     * - シルバーデイ
     *   - 毎月10日は65歳以上のお客様に限り、プラス10ポイント
     * - ポイント2倍
     *   - 月曜日は購入額にかかわらずポイント2倍
     *   - 曜日にかかわらず5,000円以上購入するとポイント2倍
     * - どちらにも該当しない
     *   - 上記以外は購入額の1%をポイントとして付与
     * - サンプル問題のため、異常系は対象外とする
     *
     * TODO List
     * - シルバーデイ
     *   - 毎月10日は65歳以上のお客様に限り、プラス10ポイント
     *     - [x] 購入日が10日かつ購入者の年齢が65歳以上で購入額が100円の場合、11ポイントを返却すること
     *     - [x] シルバーデイ（購入日が10日かつ購入者の年齢が65歳以上）かつ購入額が5000円の場合、110ポイントを返却すること
     *     - [x] 購入日が10日かつ購入者の年齢が65歳以上で購入額が99円の場合、0ポイントを返却すること
     * - ポイント2倍
     *   - 月曜日は購入額にかかわらずポイント2倍
     *     - [ ] 引数の日付が月曜日の場合、ポイントを2倍すること
     *       - [x] 購入日が月曜日で購入額が100円の場合、2ポイントを返却すること
     *       - [x] 購入日が月曜日で購入額が4999円の場合、98ポイントを返却すること
     *   - 曜日にかかわらず5,000円以上購入するとポイント2倍
     *     - [x] 購入額が5,000円以上の場合、100ポイントを返却すること
     *     - [x] 購入額が10,000円以上の場合、200ポイントを返却すること
     *   - [ ] 5,000円以上購入かつ月曜日の場合、ポイントを2倍すること(4倍=2x2にはしない)
     *     - [x] 購入日が月曜日で購入額が5000円の場合、100ポイントを返却すること
     * - どちらにも該当しない
     *   - 上記以外は購入額の1%をポイントとして付与
     *     - [ ] 引数の金額の1%をポイントとして返却すること
     *       - [x] 購入額が100円の場合、1ポイントを返却すること
     *       - [x] 購入額が99円の場合、0ポイントを返却すること
     *       - [x] 購入額が4999円の場合、49ポイントを返却すること
     */
    group("購入額の1%をポイントとして付与", () {
      test('購入額が99円の場合、0ポイントを返却すること', () {
        PurchaseDate notMonday = PurchaseDate.fromValue(DateTime(2024, 9, 22));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(99);

        final actual =
            CalculateMemberPoints.calculate(notMonday, purchaseAmount);

        expect(0, actual.value);
      });

      test('購入額が100円の場合、1ポイントを返却すること', () {
        PurchaseDate notMonday = PurchaseDate.fromValue(DateTime(2024, 9, 22));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(100);

        final actual =
            CalculateMemberPoints.calculate(notMonday, purchaseAmount);

        expect(1, actual.value);
      });

      test('購入額が4999円の場合、49ポイントを返却すること', () {
        PurchaseDate notMonday = PurchaseDate.fromValue(DateTime(2024, 9, 22));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(4999);

        final actual =
            CalculateMemberPoints.calculate(notMonday, purchaseAmount);

        expect(49, actual.value);
      });
    });

    group("月曜日は購入額にかかわらずポイント2倍", () {
      test("購入日が月曜日で購入額が100円の場合、2ポイントを返却すること", () {
        PurchaseDate monday = PurchaseDate.fromValue(DateTime(2024, 9, 23));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(100);

        final actual = CalculateMemberPoints.calculate(monday, purchaseAmount);

        expect(2, actual.value);
      });

      test("購入日が月曜日で購入額が4999円の場合、98ポイントを返却すること", () {
        PurchaseDate monday = PurchaseDate.fromValue(DateTime(2024, 9, 23));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(4999);

        final actual = CalculateMemberPoints.calculate(monday, purchaseAmount);

        expect(98, actual.value);
      });
    });

    group("曜日にかかわらず5,000円以上購入するとポイント2倍", () {
      test('購入額が5,000円以上の場合、100ポイントを返却すること', () {
        PurchaseDate notMonday = PurchaseDate.fromValue(DateTime(2024, 9, 22));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(5000);

        final actual =
            CalculateMemberPoints.calculate(notMonday, purchaseAmount);

        expect(100, actual.value);
      });

      test('購入額が10,000円以上の場合、200ポイントを返却すること', () {
        PurchaseDate notMonday = PurchaseDate.fromValue(DateTime(2024, 9, 22));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(10000);

        final actual =
            CalculateMemberPoints.calculate(notMonday, purchaseAmount);

        expect(200, actual.value);
      });
    });

    group("5,000円以上購入かつ月曜日の場合、ポイントを2倍すること(4倍=2x2にはしない)", () {
      test('購入日が月曜日で購入額が5000円の場合、100ポイントを返却すること', () {
        PurchaseDate monday = PurchaseDate.fromValue(DateTime(2024, 9, 23));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(5000);

        final actual = CalculateMemberPoints.calculate(monday, purchaseAmount);

        expect(100, actual.value);
      });
    });

    group("毎月10日は65歳以上のお客様に限り、プラス10ポイント", () {
      test("購入日が10日かつ購入者の年齢が65歳以上で購入額が100円の場合、11ポイントを返却すること", () {
        PurchaseDate notMonday10th = PurchaseDate.fromValue(DateTime(2024, 9, 10));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(100);

        final actual = CalculateMemberPoints.calculate(notMonday10th, purchaseAmount, isAge65OrOlder: true);

        expect(11, actual.value);
      });

      test("シルバーデイ（購入日が10日かつ購入者の年齢が65歳以上）かつ購入額が5000円の場合、110ポイントを返却すること", () {
        PurchaseDate notMonday10th = PurchaseDate.fromValue(DateTime(2024, 9, 10));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(5000);

        final actual = CalculateMemberPoints.calculate(
            notMonday10th, purchaseAmount,
            isAge65OrOlder: true);

        expect(110, actual.value);
      });

      test("購入日が10日かつ購入者の年齢が65歳以上で購入額が99円の場合、0ポイントを返却すること", () {
        PurchaseDate notMonday10th =
            PurchaseDate.fromValue(DateTime(2024, 9, 10));
        PurchaseAmount purchaseAmount = PurchaseAmount.fromValue(99);

        final actual = CalculateMemberPoints.calculate(
            notMonday10th, purchaseAmount,
            isAge65OrOlder: true);

        expect(0, actual.value);
      });
    });
  });
}
