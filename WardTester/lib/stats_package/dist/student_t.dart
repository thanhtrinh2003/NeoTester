part of 'dists.dart';

/// TODO
class StudentT extends ContinuousRV {
  /// Degree of freedom
  final double df;

  final double _mean;

  final double _variance;

  final double _skewness;

  final double _kurtosis;

  final double _pdfConst;

  final double _pdfExp;

  final double _halfDf;

  StudentT(this.df)
      : _mean = df > 1 ? 0.0 : double.nan,
        _variance =
            df > 2 ? df / (df - 2) : (df > 1 ? double.infinity : double.nan),
        _skewness = df > 3 ? 0.0 : double.nan,
        _kurtosis =
            df < 2 ? double.nan : (df <= 4 ? double.infinity : 6 / (df - 4)),
        _pdfConst = math.gamma((df + 1) / 2) /
            (math.sqrt(df * math.pi) * math.gamma(df / 2)),
        _pdfExp = -(df + 1) / 2,
        _halfDf = df / 2.0 {
    if (df <= 0)
      throw ArgumentError.value(df, "df", "Should be greater than 0");
  }

  double mean() => _mean;

  double median() => 0.0;

  double mode() => 0.0;

  double variance() => _variance;

  double skewness() => _skewness;

  double kurtosis() => _kurtosis;

  double std() => math.sqrt(variance());

  @override
  double relStd() {
    // TODO
    throw UnimplementedError();
  }

  @override
  double pdf(double x) => _pdfConst * math.pow(1 + ((x * x) / df), _pdfExp);

  @override
  double cdf(double x) {
    if (x == 0) {
      return 0.5;
    } else {
      double t = math.ibetaReg(this._halfDf, 0.5, df / (df + (x * x)));
      if (x < 0) {
        return 0.5 * t;
      } else {
        return 1 - 0.5 * t;
      }
    }
  }

  double ppf(double q) {
    double fac = math.ibetaInv(_halfDf, 0.5, 2 * math.min(q, 1 - q));
    double y = math.sqrt(df * (1 - fac) / fac);
    return (q > 0.5) ? y : -y;
  }

  double invT(double q) {
    return ppf(q);
  }

  @override
  double sample() {
    //TODO
    throw UnimplementedError();
  }

  double sampleMany(int count) {
    //TODO
    throw UnimplementedError();
  }
}
