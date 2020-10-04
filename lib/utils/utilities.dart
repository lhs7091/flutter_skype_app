class Utils {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    print("class : Utils  method : getInitials start");
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial;
    if (nameSplit.length > 2) {
      lastNameInitial = nameSplit[1][0];
    } else {
      lastNameInitial = "";
    }

    print("class : Utils  method : getInitials end");
    return firstNameInitial + lastNameInitial;
  }
}
