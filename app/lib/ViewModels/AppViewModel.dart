import 'package:skate/Base/BaseViewModel.dart';

class AppViewModel extends BaseViewModel {
  static String _id;

  static void setId(String id) => _id = id;

  static String get id => _id;
}
