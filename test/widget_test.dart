import 'dart:math';

class SigmoidNode {
  double threshold;
  List<double> weights;

  SigmoidNode(this.threshold, this.weights);

  double calculateOutput(List<double> inputs) {
    double sum = 0.0;
    for (int i = 0; i < inputs.length; i++) {
      sum += inputs[i] * weights[i];
    }
    return 1 / (1 + exp(-(sum - threshold)));
  }
}

class NeuralNetwork {
  SigmoidNode node0 = SigmoidNode(-5.922496815729731,
      [3.6363784969793307, 3.7906641543677244, 2.5895750528658517]);
  SigmoidNode node1 = SigmoidNode(5.922237242947766,
      [-3.635884235486743, -3.790646999055763, -2.589903880725126]);
  SigmoidNode node2 = SigmoidNode(3.428618918409652, [
    6.957627444173269,
    -2.1530248912049768,
    -0.09886954675882256,
    -0.020675029666787637
  ]);
  SigmoidNode node3 = SigmoidNode(1.74958905464268, [
    1.4182652393641808,
    8.17749478205491,
    1.1256858896750626,
    -0.8367907649846659
  ]);
  SigmoidNode node4 = SigmoidNode(0.7306254267625251, [
    5.856943434810673,
    -0.37661901673733766,
    0.3955793367212564,
    -3.02702122117242
  ]);

  NeuralNetwork();

  String classify(double hsc_p, double degree_p, double etest_p, double mba_p) {
    List<double> inputs = [hsc_p, degree_p, etest_p, mba_p];
    double output4 = node4.calculateOutput(inputs);
    double output3 = node3.calculateOutput(inputs);
    double output2 = node2.calculateOutput(inputs);
    double output0 = node0.calculateOutput([output4, output3, output2]);
    double output1 = node1.calculateOutput([output4, output3, output2]);

    if (output0 > output1) {
      return "Class Placed";
    } else {
      return "Class Not Placed";
    }
  }
}

void main() {
  // Define sigmoid nodes
  print("START");

  // Create neural network
  NeuralNetwork neuralNetwork = NeuralNetwork();

  // Test the neural network
  double hsc_p = 80.0;
  double degree_p = 75.0;
  double etest_p = 65.0;
  double mba_p = 70.0;

  String result = neuralNetwork.classify(hsc_p, degree_p, etest_p, mba_p);
  print("Result: $result");
}
