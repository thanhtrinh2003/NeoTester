import 'dart:collection';

class Test {
  //variables
  var name; //String
  var questionOrder; //Queue<int>
  var timeStart; //DateTime
  var timeEnd; //DateTime
  var totalNumQuestion; //int
  var totalAttempt; //int

  Test(var name, var questionOrder, var timeStart, var timeEnd, var totalNumQuestion, var totalAttempt)
  {
    this.name = name;
    this.questionOrder = questionOrder;
    this.timeStart = timeStart;
    this.timeEnd = timeEnd;
    this.totalNumQuestion = totalNumQuestion;
    this.totalAttempt = totalAttempt;
  }

  Map toJson() => {
        'name': name,
        'questionOrder': questionOrder, 
        'timeStart' : timeStart, 
        'timeEnd' : timeEnd, 
        'totalNumQuestion' : totalNumQuestion,
        'totalAttempt' : totalAttempt
      };
}
