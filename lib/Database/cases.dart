class CaseStat{
  String countryName;
  String iso2;

  List<CaseCount> cases;

  CaseStat(String countryName, String iso2){
    this.countryName = countryName;
    this.iso2 = iso2;
    cases = new List();
  }

}


class CaseCount {
  String date;
  int infected;
  int deceased;
  int recovered;
  int active;

  CaseCount();
}