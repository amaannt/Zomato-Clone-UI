class LanguageInformation {
  bool isLanguageError = false;
  bool isEnglish = true;
  bool isPortuguese = false;
  String currentLanguage = "English";
  setLanguageInformation(String languageSelected) {
    setAllFalse();
    switch (languageSelected) {
      case "English":
        isEnglish = true;
        currentLanguage = "English";
        break;
      case "Portuguese":
        isPortuguese = true;
        currentLanguage = "Portuguese";
        break;
      default:
        isEnglish = true;
        currentLanguage = "English";
        isLanguageError = true;
        break;
    }
  }

  setAllFalse() {
    isEnglish = false;
    isPortuguese = false;
  }
  getActiveLanguage(){
   return currentLanguage;
  }
}
