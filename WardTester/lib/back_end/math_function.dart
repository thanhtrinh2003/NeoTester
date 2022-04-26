import 'dart:math';

// ignore: import_of_legacy_library_into_null_safe
import 'package:math_expressions/math_expressions.dart';
import 'math.dart';
import 'distuv.dart';

//normal cdf
double normCDF(double mean, double sd, double lb, double ub) {
  Normal n = Normal(mean, sd);
  return n.cdf(ub) - n.cdf(lb);
}

// inverse CDF
double invNormCDF(double mean, double sd, double pc) {
  return normalInv(pc) * sd + mean;
}

// factorial
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

//binomial
double binomialPDF(double trials, double prob, double k) {
  return factorial(trials) /
      (factorial(k) * factorial(k - trials)) *
      pow(prob, k) *
      pow(1 - prob, trials - k);
}

double binomialCDF(double trials, double prob, double k) {
  Binomial a = Binomial(trials, prob);
  return a.cdf(k);
}

//geometric
double geometPDF(double prob, double trials) {
  return prob * pow(1 - prob, trials - 1);
}

double geometCDF(double prob, double trials) {
  Geometric a = Geometric(prob);
  return a.cdf(trials);
}

double chiSquaredCDF(double degrees, double lb, double ub) {
  ChiSquared cs = ChiSquared(degrees);
  return cs.cdf(ub) - cs.cdf(lb);
}

double tDistCDF(double df, double lb, double ub) {
  StudentT t = StudentT(df);
  return t.cdf(ub) - t.cdf(lb);
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
