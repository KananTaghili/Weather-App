import 'dart:convert';

Weather weatherFromMap(String str) => Weather.fromMap(json.decode(str));

String weatherToMap(Weather data) => json.encode(data.toMap());

class Weather {
  Weather({
    required this.location,
    required this.current,
    required this.forecast,
  });

  final Location location;
  final Current current;
  final Forecast forecast;

  factory Weather.fromMap(Map<String, dynamic> json) => Weather(
    location: Location.fromMap(json["location"]),
    current: Current.fromMap(json["current"]),
    forecast: Forecast.fromMap(json["forecast"]),
  );

  Map<String, dynamic> toMap() => {
    "location": location.toMap(),
    "current": current.toMap(),
    "forecast": forecast.toMap(),
  };
}

class Current {
  Current({
    required this.tempC,
    required this.condition,
    required this.windKph,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.uv,
  });

  final double tempC;
  final CurrentCondition condition;
  final double windKph;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double uv;

  factory Current.fromMap(Map<String, dynamic> json) => Current(
    tempC: json["temp_c"],
    condition: CurrentCondition.fromMap(json["condition"]),
    windKph: json["wind_kph"],
    humidity: json["humidity"],
    cloud: json["cloud"],
    feelslikeC: json["feelslike_c"],
    uv: json["uv"],
  );

  Map<String, dynamic> toMap() => {
    "temp_c": tempC,
    "condition": condition.toMap(),
    "wind_kph": windKph,
    "humidity": humidity,
    "cloud": cloud,
    "feelslike_c": feelslikeC,
    "uv": uv,
  };
}

class CurrentCondition {
  CurrentCondition({
    required this.text,
    required this.icon,
  });

  final String text;
  final String icon;

  factory CurrentCondition.fromMap(Map<String, dynamic> json) => CurrentCondition(
    text: json["text"],
    icon: json["icon"],
  );

  Map<String, dynamic> toMap() => {
    "text": text,
    "icon": icon,
  };
}

class Forecast {
  Forecast({
    required this.forecastday,
  });

  final List<Forecastday> forecastday;

  factory Forecast.fromMap(Map<String, dynamic> json) => Forecast(
    forecastday: List<Forecastday>.from(json["forecastday"].map((x) => Forecastday.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "forecastday": List<dynamic>.from(forecastday.map((x) => x.toMap())),
  };
}

class Forecastday {
  Forecastday({
    required this.date,
    required this.day,
    required this.astro,
    required this.hour,
  });

  final DateTime date;
  final Day day;
  final Astro astro;
  final List<Hour> hour;

  factory Forecastday.fromMap(Map<String, dynamic> json) => Forecastday(
    date: DateTime.parse(json["date"]),
    day: Day.fromMap(json["day"]),
    astro: Astro.fromMap(json["astro"]),
    hour: List<Hour>.from(json["hour"].map((x) => Hour.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "day": day.toMap(),
    "astro": astro.toMap(),
    "hour": List<dynamic>.from(hour.map((x) => x.toMap())),
  };
}

class Astro {
  Astro({
    required this.sunrise,
    required this.sunset,
  });

  final String sunrise;
  final String sunset;

  factory Astro.fromMap(Map<String, dynamic> json) => Astro(
    sunrise: json["sunrise"],
    sunset: json["sunset"],
  );

  Map<String, dynamic> toMap() => {
    "sunrise": sunrise,
    "sunset": sunset,
  };
}

class Day {
  Day({
    required this.maxtempC,
    required this.mintempC,
    required this.condition,
  });

  final double maxtempC;
  final double mintempC;
  final DayCondition condition;

  factory Day.fromMap(Map<String, dynamic> json) => Day(
    maxtempC: json["maxtemp_c"].toDouble(),
    mintempC: json["mintemp_c"].toDouble(),
    condition: DayCondition.fromMap(json["condition"]),
  );

  Map<String, dynamic> toMap() => {
    "maxtemp_c": maxtempC,
    "mintemp_c": mintempC,
    "condition": condition.toMap(),
  };
}

class DayCondition {
  DayCondition({
    required this.text,
    required this.icon,
    required this.code,
  });

  final String text;
  final String icon;
  final int code;

  factory DayCondition.fromMap(Map<String, dynamic> json) => DayCondition(
    text: json["text"],
    icon: json["icon"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "text": text,
    "icon": icon,
    "code": code,
  };
}

class Hour {
  Hour({
    required this.time,
    required this.tempC,
    required this.condition,
  });

  final String time;
  final double tempC;
  final CurrentCondition condition;

  factory Hour.fromMap(Map<String, dynamic> json) => Hour(
    time: json["time"],
    tempC: json["temp_c"].toDouble(),
    condition: CurrentCondition.fromMap(json["condition"]),
  );

  Map<String, dynamic> toMap() => {
    "time": time,
    "temp_c": tempC,
    "condition": condition.toMap(),
  };
}

class Location {
  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  factory Location.fromMap(Map<String, dynamic> json) => Location(
    name: json["name"],
    region: json["region"],
    country: json["country"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    tzId: json["tz_id"],
    localtimeEpoch: json["localtime_epoch"],
    localtime: json["localtime"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "region": region,
    "country": country,
    "lat": lat,
    "lon": lon,
    "tz_id": tzId,
    "localtime_epoch": localtimeEpoch,
    "localtime": localtime,
  };
}
