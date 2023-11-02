class Validators {
  static emailValidate(String? value) {
    if (value!.isEmpty) {
      return "Value can not be empty";
    }
  }
}
