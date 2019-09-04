import 'package:form_bloc/form_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginResponse {
  saveEmailAndFail,
  wrongPassword,
  networkRequestFailed,
  success,
}

class ComplexLoginFormBloc extends FormBloc<String, String> {
  static const String _usedEmailsKey = 'usedEmails';

  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );
  final passwordField = TextFieldBloc<String>(
    validators: [Validators.notEmpty],
  );
  final responseField = SelectFieldBloc<LoginResponse>(
    items: LoginResponse.values,
  );

  @override
  List<FieldBloc> get fieldBlocs =>
      [emailField, passwordField, responseField, responseField];

  ComplexLoginFormBloc() {
    emailField.updateSuggestions(suggestUsedEmails);
    emailField.onSuggestRemoved.listen(_deleteEmail);
  }

  Future<List<String>> suggestUsedEmails(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_usedEmailsKey);
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...
    await Future<void>.delayed(Duration(seconds: 2));

    switch (responseField.currentState.value) {
      case LoginResponse.saveEmailAndFail:
        await _saveEmail();
        yield currentState.toFailure();
        break;
      case LoginResponse.wrongPassword:
        yield currentState.toFailure(
          'The password is invalid or the user does not have a password.',
        );
        break;
      case LoginResponse.networkRequestFailed:
        yield currentState.toFailure(
          'Network error: Please check your internet connection.',
        );
        break;

      case LoginResponse.success:
        await _saveEmail();
        yield currentState.toSuccess();
        break;
    }
  }

  Future<void> _saveEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final usedEmails = prefs.getStringList(_usedEmailsKey) ?? [];
    final email = emailField.currentState.value;
    if (!usedEmails.contains(email)) {
      usedEmails.add(email);
      prefs.setStringList(_usedEmailsKey, usedEmails);
    }
  }

  Future<void> _deleteEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usedEmails = prefs.getStringList(_usedEmailsKey) ?? [];
    usedEmails.remove(email);
    prefs.setStringList(_usedEmailsKey, usedEmails);
  }
}
