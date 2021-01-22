bool isPhoneNumberValid(String phone){
  return (phone.isNotEmpty && phone.length == 10 && phone.contains(RegExp("^[0-9]*\$")))? true : false;
}