import 'package:math_expressions/math_expressions.dart';
import 'math_function.dart';
import 'math.dart';
import 'distuv.dart';
import 'dart:math';

Parser p = Parser();

void normalCDF_parser() {
  p.addFunction(
      'normCDF',
      (List<double> args) => args.length == 4
          ? normCDF(args[1], lb: args[0], mean: args[2], sd: args[3])
          : args.length == 3
              ? normCDF(args[0], mean: args[1], sd: args[2])
              : args.length == 2
                  ? normCDF(args[1], lb: args[0])
                  : normCDF(args[0]));
}

void inverseNormalCDF_parser() {
  p.addFunction(
      'invNorm',
      (List<double> args) => args.length == 1
          ? invNormCDF(args[0])
          : invNormCDF(args[0], mean: args[1], sd: args[2]));
  ;
}

void tDistCDF_parser() {
  p.addFunction(
      'tcdf', (List<double> args) => tDistCDF(args[1], args[2], lb: args[0]));
}

void chiSquaredCDF_parser() {
  p.addFunction(
      'chicdf',
      (List<double> args) => args.length == 2
          ? chiSquaredCDF(args[1], args[2], lb: args[0])
          : chiSquaredCDF(args[0], args[1]));
}

void binomialPDF_parser() {
  p.addFunction(
      'binPDF', (List<double> args) => binomialPDF(args[0], args[1], args[2]));
}

void binomialCDF_parser() {
  p.addFunction(
      'binCDF',
      (List<double> args) => args.length == 3
          ? binomialCDF(args[0], args[1], args[2])
          : binomialCDF(args[0], args[1], args[3], lb: args[2]));
}

void geometPDF_parser() {
  p.addFunction('geomPDF', (List<double> args) => geomPDF(args[0], args[1]));
}

void geometCDF_parser() {
  p.addFunction(
      'geomCDF',
      (List<double> args) => args.length == 2
          ? geomCDF(args[0], args[1])
          : geomCDF(args[0], args[2], lb: args[1]));
}

void median_parser() {
  p.addFunction('median', (List<double> args) => median(args));
}

void stddev_parser() {
  p.addFunction('stddev', (List<double> args) => stddev(args));
}

void average_parser() {
  p.addFunction('average', (List<double> args) => average(args));
}

void permutation_parser() {
  p.addFunction('nCr', (List<double> args) => permutation(args[0], args[1]));
}

void combination_parser() {
  p.addFunction('nPr', (List<double> args) => combination(args[0], args[1]));
}

void min_parser() {
  p.addFunction('min', (List<double> args) => min(args));
}

void max_parser() {
  p.addFunction('max', (List<double> args) => max(args));
}

void floor_parser() {
  p.addFunction('floor', (List<double> args) => floor(args[0]));
}

void ceil_parser() {
  p.addFunction('ceil', (List<double> args) => ceil(args[0]));
}

void gcf_parser() {
  p.addFunction(
      'gcf', (List<double> args) => gcf(args[0].toInt(), args[1].toInt()));
}

void lcm_parser() {
  p.addFunction(
      'lcm', (List<double> args) => gcf(args[0].toInt(), args[1].toInt()));
}

void abs_parser() {
  p.addFunction('abs', (List<double> args) => abs(args[0]));
}

void sum_parser() {
  p.addFunction('sum', (List<double> args) => sum(args));
}

void count_parser() {
  p.addFunction('count', (List<double> args) => args.length);
}

void nthroot_parser() {
  p.addFunction('nthroot', (List<double> args) => nthroot(args[0], args[1]));
}

void pi_parser() {
  p.addFunction('pi', (List<double> args) => pi);
}

void e_parser() {
  p.addFunction('e', (List<double> args) => e);
}
