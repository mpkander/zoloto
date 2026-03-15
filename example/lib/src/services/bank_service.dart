import '../models/bank_screen_data.dart';

class BankService {
  BankScreenData _data = const BankScreenDataLoading();

  BankScreenData getData() => _data;

  void setData(BankScreenData data) {
    _data = data;
  }
}
