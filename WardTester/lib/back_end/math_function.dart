import 'dart:math';

// ignore: import_of_legacy_library_into_null_safe
import 'package:math_expressions/math_expressions.dart';
import 'math.dart';
import 'distuv.dart';

///returns the probabilty below or between the bounds in the normal distribution
double normCDF(double mean, double sd, double lb, double ub) {
  print("mean: ${mean} sd: $sd  lb: $lb  ub: $ub");
  Normal n = Normal(mean, sd);
  return n.cdf(ub) - n.cdf(lb);
}

///returns the z value given the probability
double invNormCDF(double mean, double sd, double area) {
  return normalInv(area) * sd + mean;
}

///returns the probabilty below or between the bounds in the student t distribution
double tDistCDF(double df, double lb, double ub) {
  StudentT t = StudentT(df);
  return t.cdf(ub) - t.cdf(lb);
}

///returns the t value given the probability
double invT(double df, double area) {
  StudentT t = StudentT(df);
  return t.invT(area);
}

///returns the probabilty below or between the bounds in the chi-sqaured distribution
double chiSquaredCDF(double degrees, double lb, double ub) {
  ChiSquared cs = ChiSquared(degrees);
  return cs.cdf(ub) - cs.cdf(lb);
}

/// returns the probability of a given binomial event
double binomialPDF(double trials, double prob, double k) {
  return factorial(trials) /
      (factorial(k) * factorial(k - trials)) *
      pow(prob, k) *
      pow(1 - prob, trials - k);
}

/// returns the probability of a range of binomial event
double binomialCDF(double trials, double prob, double lb, double ub) {
  Binomial a = Binomial(trials, prob);
  return a.cdf(ub) - a.cdf(lb - 1);
}

///returns the probability of a given geometric event
double geomPDF(double prob, double trials) {
  return prob * pow(1 - prob, trials - 1);
}

///returns the probability of a range of geometric events
double geomCDF(double prob, double lb, double ub) {
  Geometric a = Geometric(prob);
  return a.cdf(ub) - a.cdf(lb - 1);
}

int median(List<double> a) {
  var clonedList = <int>[];
  for (int i = 0; i < a.length; i++) {
    clonedList.add(a[i].toInt());
  }

  clonedList.sort((a, b) => a.compareTo(b));

  int median;

  int middle = clonedList.length ~/ 2;
  if (clonedList.length % 2 == 1) {
    median = clonedList[middle];
  } else {
    median = ((clonedList[middle - 1] + clonedList[middle]) / 2.0).round();
  }

  return median;
}

double stddev(List<double> a) {
  double mean = average(a);
  double sum = 0;
  for (int i = 0; i < a.length; i++) {
    sum = sum + (a[i] - mean) * (a[i] - mean);
  }
  return sqrt(sum / a.length);
}

double average(List<double> a) {
  double sum = 0;
  int count = 0;
  for (int i = 0; i < a.length; i++) {
    sum = sum + a[i];
    count = count + 1;
  }
  return sum / count;
}

double min(List<double> a) {
  double min = double.infinity;
  for (int i = 0; i < a.length; i++) {
    if (a[i] < min) {
      min = a[i];
    }
  }
  return min;
}

double max(List<double> a) {
  double max = double.negativeInfinity;
  for (int i = 0; i < a.length; i++) {
    if (a[i] > max) {
      max = a[i];
    }
  }
  return max;
}

int floor(double a) {
  return a.floor();
}

int ceil(double a) {
  return (a.floor() + 1);
}

int gcf(int a, int b) {
  return a.gcd(b);
}

double lcm(int a, int b) {
  return a * b / gcf(a, b);
}

double abs(double a) {
  return a >= 0 ? a : -a;
}

double sum(List a) {
  double sum = 0;
  for (int i = 0; i < a.length; i++) {
    sum = sum + a[i];
  }
  return sum;
}

double nthroot(double number, double root) {
  return pow(number, root).toDouble();
}

double factorial(double n) {
  double product = 1;
  if (n == 0) {
    return 1;
  }
  for (int i = 1; i <= n; i++) {
    product *= i;
  }
  return product;
}

//permutation
double permutation(double n, double r) {
  return factorial(n) / factorial(n - r);
}

//combination
double combination(double n, double r) {
  return factorial(n) / (factorial(r) * factorial(n - r));
}

Random random = new Random();

T getRandomElement<T>(List<T> list) {
  final random = new Random();
  var i = random.nextInt(list.length);
  return list[i];
}

bool isInteger(num value) => value is int || value == value.roundToDouble();

double generateRandom(double lb, double rb, double steps) {
  var list = [lb];
  for (double i = lb + steps; i <= rb; i = i + steps) {
    list.add(i);
  }
  return getRandomElement(list);
}

double generateRandomNoStep(double lb, double rb) {
  int track = 1;
  while (!isInteger(lb)) {
    lb = lb * 10;
    rb = rb * 10;
    track *= 10;
  }
  int lbInt = lb.toInt();
  int rbInt = rb.toInt();
  int randomNumber = random.nextInt(rbInt - lbInt + 1) + lbInt;
  return randomNumber.toDouble() / track;
}

double logBase(num x, num base) => log(x) / log(base);

int binaryToDecimal(int a) {
  return int.parse(a.toString(), radix: 2);
}

String binaryToHex(int a) {
  return int.parse(a.toString(), radix: 2).toRadixString(16);
}

int decimalToBinary(int a) {
  return int.parse(a.toRadixString(2));
}

String decimalToHex(int a) {
  return a.toRadixString(16);
}

int hexToBinary(String a) {
  return int.parse(int.parse(a, radix: 16).toRadixString(2));
}

int hexToDecimal(String a) {
  return int.parse(a, radix: 16);
}
