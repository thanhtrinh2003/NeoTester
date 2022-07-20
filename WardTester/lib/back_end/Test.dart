import 'dart:collection';

class Test {
  //variables
  var name; //String
  var questionOrder; //Queue<int>
  var timeStart; //DateTime
  var timeEnd; //DateTime
  var totalNumQuestion; //int
  var totalAttempt; //int

  /// test which hasnt done was not doing anything
  Test(var name, var questionOrder, var timeStart, var timeEnd,
      var totalNumQuestion, var totalAttempt) {
    this.name = name;
    this.questionOrder = questionOrder;
    this.timeStart = timeStart;
    this.timeEnd = timeEnd;
    this.totalNumQuestion = totalNumQuestion;
    this.totalAttempt = totalAttempt;
  }

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

  void setTimeStart(var timeStart) {
    this.timeStart = timeStart;
  }

  void setTimeEnd(var timeEnd) {
    this.timeEnd = timeEnd;
  }
}

Queue<int> turnStringToQueue(String listString) {
  final List<String> list = listString.split(', ');
  Queue<int> listInt = new Queue();
  for (var a in list) {
    listInt.add(int.parse(a));
  }
  return listInt;
}
