class Sales {
  final int income;
  final int expense;
  Sales(this.income, this.expense);

  Sales.fromMap(Map<String, dynamic> map)
      : assert(map['income'] != null),
        assert(map['expense'] != null),
        income = map['income'],
        expense = map['expense'];

  @override
  String toString() => "Record<$income:$expense:>";
}
