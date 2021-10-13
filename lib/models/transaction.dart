class Transaction {
  //proporties
  String id;
  String title;
  double amount;
  DateTime date;

  //add constructor
  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
}
