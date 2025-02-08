import 'package:flutter/material.dart';
import 'package:pumba_project/dao/shared_prefs.dart';
import 'package:pumba_project/dao/users_repository.dart';
import 'package:pumba_project/model/User.dart';

class LoginViewModel extends ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharedPrefs _sharedPrefs;
  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;
  final TextEditingController _emailController;
  String? selectedGender;

  bool _isLoading = false;
  String? _errorMsg;

  LoginViewModel(this._sharedPrefs)
      : _firstNameController = TextEditingController(),
        _lastNameController = TextEditingController(),
        _emailController = TextEditingController();

  bool get isLoading => _isLoading;

  String? get errorMsg => _errorMsg;

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get firstNameController => _firstNameController;

  TextEditingController get lastNameController => _lastNameController;

  TextEditingController get emailController => _emailController;

  Future<void> registerUser() async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();

      final repo = UsersRepository();
      final id = await repo.saveUser(
        User(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          selectedGender!,
        ),
      );
      if (id != null) {
        _sharedPrefs.setUserId(id);
      } else {
        _errorMsg = "Failed to save details, try again later";
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
