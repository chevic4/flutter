// ignore_for_file: unrelated_type_equality_checks

import 'package:mobx/mobx.dart';
import 'package:validators2/validators.dart';
part 'form_store.g.dart';

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore with Store {
  final error = FormErrorState();

  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  ObservableFuture<bool> usernameCheck = ObservableFuture.value(true);

  @computed
  bool get isUserCheckPending => usernameCheck.status == FutureStatus.pending;

  @computed                               //
  bool get canLogin =>!error.hasErrors;   //

  late List<ReactionDisposer> _disposers;

  void setupValidators() {
    _disposers = [
      reaction((_) => name, validateUsername),
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword),
    ];
  }

  @action
  void validatePassword(String value) {
    const passwordList = 'qwe';
    if (value == passwordList) {
      error.password = null;
    } else {
      error.password = 'enter correct password';
    }
  }
  @action
  void validateEmail(String value) {
    if (isEmail(value)){
      error.email = null;
    } else { error.email= 'enter correct email';}
  }

  @action
  Future validateUsername(String value) async {
    if (isNull(value) || value.isEmpty) {
      error.username = 'Field is required';
      return;
    }

    try {
      usernameCheck = ObservableFuture(checkValidUsername(value));

      error.username = null;

      final isValid = await usernameCheck;
      if (!isValid) {
        error.username = 'Username cannot be "admin"';
        return;
      }
    } on Object catch (_) {
      error.username = null;
    }

    error.username = null;
  }

  Future<bool> checkValidUsername(String value) async {
    await Future.delayed(const Duration(seconds: 1));

    return value != 'admin';
  }

  void validateAll() {
    validateUsername(name);
    validateEmail(email);
    validatePassword(password);
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String? username = '';

  @observable
  String? email = '';

  @observable
  String? password = '';

  @computed
  bool get hasErrors => username != null || email != null || password != null;
}
