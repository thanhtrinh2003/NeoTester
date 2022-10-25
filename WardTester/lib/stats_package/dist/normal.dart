part of 'dists.dart';

class Normal extends ContinuousRV {
  final double mu;

  final double sigma;

  Normal._(this.mu, this.sigma);

  factory Normal(double mu, double sigma) {
    if (sigma < 0) {
      throw ArgumentError.value(sigma, 'sigma', 'Must be greater than zero');
    }
    return Normal._(mu, sigma);
  }

  double mean() => mu;

  double variance() => sigma * sigma;

  double skewness() => 0.0;

  double kurtosis() => 3.0;

  double std() => sigma;

  double relStd() => sigma / mu;

  double pdf(double x) {
    final double diff = x - mu;
    final double expo = -1 * diff * diff / (2 * variance());
    final double denom = math.sqrt(2 * variance() * math.pi);
    return math.exp(expo) / denom;
  }

  double _zpdf(num x) => math.exp(-x * x / 2) / math.sqrt(2 * math.pi);

  double cdf(num x) {
    final standardDeviation = sigma,
        z0 = (x - mu) / standardDeviation,
        z = z0.abs(),
        p = 0.2316419,
        t = 1 / (1 + p * z),
        tps = List<num>.generate((5), (i) => math.pow(t, i + 1)),
        b = [0.319381530, -0.356563782, 1.781477937, -1.821255978, 1.330274429],
        c = _zpdf(z) *
            List<int>.generate(5, (i) => i)
                .map((i) => b[i] * tps[i])
                .fold(0, (a, b) => a + b);
    return z0 < 0 ? c : 1 - c;
  }

  double ppf(double q) => math.normalInv(q);

  double sample() {
    //TODO
    throw UnimplementedError();
  }

  double sampleMany(int count) {
    //TODO
    throw UnimplementedError();
  }
}
