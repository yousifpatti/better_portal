import 'dart:math';

T randomChoice<T>(Iterable<T> options, [ Iterable<double> weights = const [] ]) {
  if (options.isEmpty) {
    throw ArgumentError.value(options.toString(), 'options', 'must be non-empty');
  }
  if (weights.isNotEmpty && options.length != weights.length) {
    throw ArgumentError.value(weights.toString(), 'weights', 'must be empty or match length of options');
  }

  if (weights.isEmpty) {
    return options.elementAt(Random().nextInt(options.length));
  }

  double sum = weights.reduce((val, curr) => val + curr);
  double randomWeight = Random().nextDouble() * sum;

  int i = 0;
  for (int l = options.length; i < l; i++) {
    randomWeight -= weights.elementAt(i);
    if (randomWeight <= 0) {
      break;
    }
  }

  return options.elementAt(i);
}



class Odometer {
  late int currentReading;
  late List<String> suburbs;
  late DateTime start;
  late DateTime end;
  late int amountToGenerate;
  Odometer(int currentReading, List<String> suburbs, DateTime start, DateTime end, int amountToGenerate) {
    this.currentReading = currentReading;
    this.suburbs = suburbs;
    this.start = start;
    this.end = end;
    this.amountToGenerate = amountToGenerate;
  }
  
  void generateTrips() {
    double total = 0.0;
    DateTime current = DateTime.now().subtract(Duration(days: 180));
    int reading = 123000;
    while (total < 100) {
      Trip trip = Trip(current, reading);
      print(trip.toString());
      current = trip.dateTime;
      reading = trip.newOdo;
    }
  }


}




class Trip {
  int speed = Random().nextInt(40) + 60; // km/hr
  int hours = randomChoice([0, 1, 2], [0.6, 0.3, 0.1]);
  int minutes = Random().nextInt(44) + 15;
  late DateTime dateTime;
  late int distance;
  late double timeTaken;
  late int newOdo;




  Trip(DateTime currentDateTime, int odo) {
    // TODO: alter the time to add gap dummy days or dummy time (depending on amount left) ensure not after 9pm
    // generating gap
    int gap_days = randomChoice([0, Random().nextInt(8) + 1], [0.6, 0.4]);
    int gap_hours = Random().nextInt(10);
    int gap_minutes = Random().nextInt(29) + 30;
    DateTime newCurrent = currentDateTime.add(Duration(days: gap_days, hours: gap_hours, minutes: gap_minutes));

    if (newCurrent.hour > 21) {
      newCurrent.add(Duration(days: 0, hours: 10));
    }
    
    dateTime = newCurrent.add(Duration(days: 0, hours: this.hours, minutes: this.minutes));
    timeTaken = hours + (minutes/60);
    distance = (speed * timeTaken).round();
    
    //fake odo addon
    int fakeOdo = Random().nextInt(36) + 14;
    fakeOdo = fakeOdo * gap_days;
    newOdo = odo + fakeOdo + distance;
  }

  @override
  String toString() {
    return "Date: $dateTime TimeTaken: $timeTaken Distance: $distance newOdo: $newOdo";
  }
}

void main() {
  //print(DateTime.now().add(Duration(0, )))

  double total = 0.0;
  DateTime current = DateTime.now().subtract(Duration(days: 180));
  int reading = 123000;
  while (total < 100) {
    Trip trip = Trip(current, reading);
    print(trip.toString());
    current = trip.dateTime;
    reading = trip.newOdo;
    total += trip.timeTaken;
  }
}