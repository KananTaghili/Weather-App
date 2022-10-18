class Languages {
  static final  List<String> weekTr = ["", "Pazartesi  ", "Salı            ", "Çarşamba", "Perşembe", "Cuma        ", "Cumartesi", "Pazar         "];
  static final List<String> weekEn = ["", "Monday      ", "Tuesday     ", "Wednesday", "Thursday    ", "Friday          ", "Saturday     ", "Sunday        "];
  static final List<String> weekRu = ["", "Понедельник", "Вторник          ", "Среда             ", "Четверг          ", "Пятница         ", "Суббота          ", "Воскресенье "];

  static final Languages en = Languages(weekEn, "Feels Like", "Sunrise", "Sunset", "Uv Index", "Low", "Medium", "High", "Very High", "Extremely High", "Wind", "Humidity", "Cloud");
  static final Languages tr = Languages(weekTr, "Gibi hissettiriyor", "Gün doğumu", "Gün batımı", "Uv Indeksi", "Düşük", "Orta", "Yüksek", "Çok yüksek", "Son derece yüksek", "Rüzgâr", "Nem", "Bulut");
  static final Languages ru = Languages(weekRu, "Как будто", "Восход", "Закат солнца", "УФ-индекс", "Низкий", "Середина", "Высокая", "Очень высоко", "Экстремально высокий", "Ветер", "Влажность", "Облако");

  static final Map<String, Languages> dictionary = {"en": en, "tr": tr, "ru": ru};

  Languages(
      this.week,
      this.feelsLike,
      this.sunrise,
      this.sunset,
      this.uvIndex,
      this.low,
      this.medium,
      this.high,
      this.veryHigh,
      this.extremelyHigh,
      this.wind,
      this.humidity,
      this.cloud);

  late List<String> week;
  late String feelsLike;
  late String sunrise;
  late String sunset;
  late String uvIndex;
  late String low;
  late String medium;
  late String high;
  late String veryHigh;
  late String extremelyHigh;
  late String wind;
  late String humidity;
  late String cloud;
}
