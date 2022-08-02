import 'dart:collection';

class Test {
  //variables
  var name; //String
  var questionOrder; //Queue<int>
  var timeStart; //DateTime
  var timeEnd; //DateTime
  var totalNumQuestion; //int
  var totalAttempt; //int

  var name_null = null; //String
  var questionOrder_null = new Queue<int>(); //Queue<int>
  var timeStart_null = DateTime.now(); //DateTime
  var timeEnd_null = DateTime.now(); //DateTime
  var totalNumQuestion_null = 0; //int
  var totalAttempt_null = 0; //int

  // test which hasnt done was not doing anything
  // Test(var name, var questionOrder, var timeStart, var timeEnd,
  //     var totalNumQuestion, var totalAttempt) {
  //   this.name = name;
  //   this.questionOrder = questionOrder;
  //   this.timeStart = timeStart;
  //   this.timeEnd = timeEnd;
  //   this.totalNumQuestion = totalNumQuestion;
  //   this.totalAttempt = totalAttempt;
  // }

  Test(this.name, this.questionOrder, this.timeStart, this.timeEnd,
      this.totalNumQuestion, this.totalAttempt);

  //Car.withoutABS(this.make, this.model, this.yearMade): this(make, model, yearMade, false);

  Test.nullOne()
      : this("null", new Queue<int>(), DateTime.now(), DateTime.now(), 0, 0);

  // factory Test.nullOne(var name, var questionOrder, var timeStart, var timeEnd, var totalNumQuestion, var totalAttempt) {
  //   	return NullTest(name, questionOrder, timeStart, timeEnd, totalNumQuestion, totalAttempt);
  //   }

  Test.fromJson(Map json)
      : name = json['name'],
        questionOrder = turnStringToQueue(json['questionOrder']),
        timeStart = DateTime.parse(json['timeStart']),
        timeEnd = DateTime.parse(json['timeStart']),
        totalNumQuestion = int.parse(json['totalNumQuestion']),
        totalAttempt = int.parse(json['totalAttempt']);

  Map toJson() => {
        'name': name,
        'questionOrder': questionOrder.toString(),
        'timeStart': timeStart.toString(),
        'timeEnd': timeEnd.toString(),
        'totalNumQuestion': totalNumQuestion.toString(),
        'totalAttempt': totalAttempt.toString()
      };

  Queue<int> getQuestionOrder() {
    return questionOrder;
  }

  String getName() {
    return name;
  }

  int getQuestionLeft() {
    return questionOrder.length;
  }

  String getTimeStart() {
    return timeStart.toString();
  }

  String getTimeEnd() {
    return timeEnd.toString();
  }

  void setTimeStart(var timeStart) {
    this.timeStart = timeStart;
  }

  void setTimeEnd(var timeEnd) {
    this.timeEnd = timeEnd;
  }

  void setQuestionOrder(var questionOrder) {
    this.questionOrder = questionOrder;
  }
}

Queue<int> turnStringToQueue(String listString) {
  //remove '{' and '}' from the String
  listString = listString.substring(1, listString.length - 1);
  final List<String> list = listString.split(', ');
  Queue<int> listInt = new Queue();
  for (var a in list) {
    print(a);
    listInt.add(int.parse(a));
  }
  return listInt;
}

// class FordCar extends Car {
// 	FordCar(String model, String yearMade, bool hasABS): super("Ford", model, yearMade, hasABS);

// }

class NullTest extends Test {
  var name = null; //String
  var questionOrder = new Queue<int>(); //Queue<int>
  var timeStart = DateTime.now(); //DateTime
  var timeEnd = DateTime.now(); //DateTime
  var totalNumQuestion = 0; //int
  var totalAttempt = 0; //int

  NullTest(var name, var questionOrder, var timeStart, var timeEnd,
      var totalNumQuestion, var totalAttempt)
      : super(name, questionOrder, timeStart, timeEnd, totalNumQuestion,
            totalAttempt);
}
