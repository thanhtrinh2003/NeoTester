import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
import '../back_end/math_function.dart';
import 'dart:convert';
import '../back_end/math_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';

Random random = new Random();

void main() {
  //variable
  Variable mean = Variable('mean');
  Variable sd = Variable('sd');
  Variable lb = Variable('lb');
  Variable ub = Variable('ub');
  Variable pc = Variable('pc');

  //Context Model
  ContextModel cm = ContextModel();

  //normalCDF
  normalCDF_parser();
  Expression exp = p.parse('normalCDF(mean, sd, lb, ub)');
  print('normalCDF(mean, sd, lb, ub) = $exp');
  cm.bindVariable(mean, Number(0));
  cm.bindVariable(sd, Number(1));
  cm.bindVariable(lb, Number(-9999));
  cm.bindVariable(ub, Number(1));
  double res = exp.evaluate(EvaluationType.REAL, cm);
  print(
      'normalCDF(${cm.getExpression('mean')},${cm.getExpression('sd')},${cm.getExpression('lb')},${cm.getExpression('ub')}) = $res');

  //inverseNormalCDF
  //inverseNormalCDF_parser();
  exp = p.parse('invNormCDF(mean, sd, pc)');
  print('invNormCDF(mean, sd, pc) = $exp');
  cm.bindVariable(mean, Number(0));
  cm.bindVariable(sd, Number(1));
  cm.bindVariable(pc, Number(0.9));
  res = exp.evaluate(EvaluationType.REAL, cm);
  print(
      'invNormCDF(${cm.getExpression('mean')}, ${cm.getExpression('sd')}, ${cm.getExpression('pc')}) = $res');
}
