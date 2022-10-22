import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../languages/languages.dart';
import '../models/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late String city, lang, days, apiAddress;
  late Languages dictionary;
  late Weather weather;
  late Location location;
  late Current current;
  late CurrentCondition currentCondition;
  late Forecastday currentDay;
  late List<Forecastday> listForecastday;

  @override
  void initState() {
    city = "Baku";
    lang = "en";
    days = "7";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<Weather> weatherList = _getWeatherList();

    return RefreshIndicator(
      onRefresh: () async {
        return Future<void>.delayed(
          const Duration(seconds: 3),
          () async {
            setState(() {
              weatherList = _getWeatherList();
            });
          },
        );
      },
      child: FutureBuilder<Weather>(
        future: weatherList,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            weather = snapshot.data!;
            init();
            return Scaffold(
              appBar: scaffoldAppBar(),
              body: scaffoldBody(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  AppBar scaffoldAppBar() {
    List<Color> colors = backGroundColorGradient();
    return AppBar(
      backgroundColor: colors[0],
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location.country,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          Text(
            location.localtime,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                _getLangDropdown(),
                const SizedBox(
                  width: 10.0,
                ),
                const Icon(
                  Icons.location_pin,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                _getCityDropdown(),
              ],
            ),
          ],
        ),
        const SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget scaffoldBody() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: backGroundColorGradient(),
        ),
      ),
      child: ListView.separated(
        separatorBuilder: (_, int index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: 5,
        itemBuilder: (_, i) {
          if (i == 0) {
            return scaffoldBodyCurrent();
          } else if (i == 1) {
            return scaffoldBodyWeekly();
          } else if (i == 2) {
            return scaffoldBodyHourly();
          } else if (i == 3) {
            return scaffoldBodyCurrentAstronomic();
          } else {
            return scaffoldBodyCurrentOther();
          }
        },
      ),
    );
  }

  Widget scaffoldBodyCurrent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: ClipOval(
              child: Image.network(
                "https:${currentCondition.icon}",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "${current.tempC.round().toString()}°C",
            style: const TextStyle(
              fontSize: 70.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            "${current.feelslikeC.round().toString()}°C ${dictionary.feelsLike}",
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            currentCondition.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget scaffoldBodyWeekly() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        shape: BoxShape.rectangle,
        color: backGroundColorGradient()[1],
        borderRadius: BorderRadiusDirectional.circular(16.0),
      ),
      child: SizedBox(
        height: 300,
        child: ListView.separated(
          itemCount: int.parse(days),
          itemBuilder: (_, int index) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dictionary.week[listForecastday[index].date.weekday],
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Image.network(
                    "https:${listForecastday[index].day.condition.icon}",
                    height: 50,
                  ),
                  Row(
                    children: [
                      Text(
                        "${listForecastday[index].day.maxtempC.round().toString()}°C",
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "${listForecastday[index].day.mintempC.round().toString()}°C",
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.transparent,
            );
          },
        ),
      ),
    );
  }

  Widget scaffoldBodyHourly() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(5),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        shape: BoxShape.rectangle,
        color: backGroundColorGradient()[1],
        borderRadius: BorderRadiusDirectional.circular(16.0),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (_, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(hour12(currentDay.hour[index].time)),
              SizedBox(
                width: 30,
                height: 30,
                child: Image.network(
                  "https:${currentDay.hour[index].condition.icon}",
                  height: 50,
                ),
              ),
              Text("${currentDay.hour[index].tempC.round()}°C"),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 50,
          );
        },
      ),
    );
  }

  Widget scaffoldBodyCurrentAstronomic() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        shape: BoxShape.rectangle,
        color: Colors.brown,
        borderRadius: BorderRadiusDirectional.circular(16.0),
      ),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  dictionary.sunrise,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  currentDay.astro.sunrise,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xff1D56A5),
                    borderRadius: BorderRadiusDirectional.circular(70.0),
                  ),
                  child: Center(
                    child: ClipOval(
                      child: Image.network(
                        "https://c.tenor.com/FQzTJNbnBtkAAAAi/goodmorning-sunrise.gif}",
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Text(
                  dictionary.sunset,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  currentDay.astro.sunset,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ClipOval(
                  child: Image.network(
                    "https://media.tenor.com/pLowlxwrWxoAAAAM/sunset.gif}",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget scaffoldBodyCurrentOther() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        shape: BoxShape.rectangle,
        color: Colors.brown,
        borderRadius: BorderRadiusDirectional.circular(16.0),
      ),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                ClipOval(
                  child: Image.network(
                    "https://img.freepik.com/premium-vector/yellow-sun-glasses-uv-protection-icon-sunblock-eye-protection-from-sunshine-solar-burn_352905-731.jpg?w=2000}",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  dictionary.uvIndex,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  uvDetect(current.uv),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                ClipOval(
                  child: Image.network(
                    "https://cdn1.iconfinder.com/data/icons/hawcons/32/699847-icon-43-wind-512.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  dictionary.wind,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  "${current.windKph} Kph",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                ClipOval(
                  child: Image.network(
                    "https://icons.iconarchive.com/icons/custom-icon-design/lovely-weather-2/512/Humidity-icon.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  dictionary.humidity,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  "${current.humidity}%",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                ClipOval(
                  child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Circle-icons-cloud.svg/2048px-Circle-icons-cloud.svg.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  dictionary.cloud,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  "${current.cloud}%",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> _getCityDropdown() {
    List<String> cityList = ["Baku", "London", "Istanbul", "Moscow"];
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      value: city,
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      selectedItemBuilder: (BuildContext context) {
        return cityList.map((String value) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              city,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList();
      },
      onChanged: (String? newCity) {
        setState(() {
          if (newCity != null) city = newCity;
        });
      },
      items: cityList.map((String city) {
        return DropdownMenuItem<String>(value: city, child: Text(city));
      }).toList(),
    );
  }

  DropdownButton<String> _getLangDropdown() {
    List<String> langList = ["en", "tr", "ru"];
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      value: lang,
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      selectedItemBuilder: (BuildContext context) {
        return langList.map((String value) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              lang,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList();
      },
      onChanged: (String? newLang) {
        setState(() {
          if (newLang != null) lang = newLang;
        });
      },
      items: langList.map((String lang) {
        return DropdownMenuItem<String>(value: lang, child: Text(lang));
      }).toList(),
    );
  }

  void init() {
    dictionary = Languages.dictionary[lang]!;
    location = weather.location;
    current = weather.current;
    currentCondition = weather.current.condition;
    currentDay = weather.forecast.forecastday[0];
    listForecastday = weather.forecast.forecastday;
  }

  Future<Weather> _getWeatherList() async {
    apiAddress =
        "https://api.weatherapi.com/v1/forecast.json?key=7feeb90028874031b0a144523221310";
    try {
      final response = await Dio().get(
        apiAddress,
        queryParameters: {'lang': lang, "q": city, "days": days},
      );
      if (response.statusCode == 200) {
        return Weather.fromMap(response.data);
      } else {
        throw Exception("404 error");
      }
    } on DioError catch (e) {
      return Future.error(e.message);
    }
  }

  String hour12(String date) {
    int hour = int.parse(date.split(" ")[1].split(":")[0]);

    if (hour >= 12) {
      if (hour == 12) {
        return "12 PM";
      }
      return "${hour - 12} PM";
    }
    return "$hour AM";
  }

  String uvDetect(double uv) {
    if (uv <= 2) {
      return dictionary.low;
    } else if (uv <= 5) {
      return dictionary.medium;
    } else if (uv <= 7) {
      return dictionary.high;
    } else if (uv <= 10) {
      return dictionary.veryHigh;
    } else {
      return dictionary.extremelyHigh;
    }
  }

  List<Color> backGroundColorGradient() {
    String currentSunset = currentDay.astro.sunset;
    String currentSunrise = currentDay.astro.sunrise;
    String currentTime = location.localtime;

    List<String> shortSunset = currentSunset.split(" ")[0].split(":");
    List<String> shortSunrise = currentSunrise.split(" ")[0].split(":");
    List<String> shortTime = currentTime.split(" ")[1].split(":");

    int timeHour = int.parse(shortTime[0]);
    int sunsetHour = int.parse(shortSunset[0]) + 12;
    int sunriseHour = int.parse(shortSunrise[0]);

    int timeMinute = int.parse(shortTime[1]);
    int sunsetMinute = int.parse(shortSunset[1]);
    int sunriseMinute = int.parse(shortSunrise[1]);

    int sunsetAll = sunsetHour * 60 + sunsetMinute;
    int sunriseAll = sunriseHour * 60 + sunriseMinute;
    int timeAll = timeHour * 60 + timeMinute;

    if (timeAll <= sunriseAll + 60 && timeAll >= sunriseAll - 60) {
      return [const Color(0xff1D56A5), const Color(0xffffa700)];
    } else if (timeAll >= sunriseAll + 60 && timeAll <= sunsetAll - 60) {
      return [const Color(0xff80ACE9), const Color(0xffB7D0F2)];
    } else if (timeAll >= sunsetAll - 60 && timeAll <= sunsetAll + 60) {
      return [const Color(0xff327ADC), const Color(0xffff8100)];
    } else {
      return [const Color(0xff454D81), const Color(0xff6b75AD)];
    }
  }
}
