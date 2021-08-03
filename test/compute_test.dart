import 'package:flutter_test/flutter_test.dart';
import 'package:sevenlake_assignment/compute.dart';

// Input Json
List<Map<String, dynamic>> inputJsonAttribute = [
  {'name': 'mass', 'type': 'number', 'value': 900},
  {'name': 'length', 'type': 'number', 'value': 2},
  {'name': 'width', 'type': 'number', 'value': 1},
  {'name': 'height', 'type': 'number', 'value': 5},
  {'name': 'densityOption', 'type': 'string', 'value': 'specGravity'}
];

// Values to be calculated from below given Json
List<Map<String, dynamic>> computeJsonAttribute = [
  {'name': 'volume', 'expression': 'length * width * height'},
  {
    'name': 'density',
    'expression':
        "IIF(densityOption == 'specGravity', mass / ( length * width * height * 0.9 ), mass / ( length * width * height ) )"
  }
];

void main() {
  Compute _compute = Compute();

  group('evaluateLogicExpressionSuccessCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test(
        'evaluateLogicExpression should return true when == operator is passed',
        () {
      String input = "densityOption == 'specGravity'";
      bool response = _compute.evaluateLogicExpression(input);
      expect(response, true);
    });
  });

  group('evaluateLogicExpressionFailCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test(
        'evaluateLogicExpression should return false when =* operator is passed',
        () {
      String input = "densityOption =* 'specGravity'";
      bool response = _compute.evaluateLogicExpression(input);
      expect(response, false);
    });
  });

  group('evaluateBracketExpressionSuccessCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateBracketExpression should succeed when valid input is passed',
        () {
      List<String> input = [
        "mass",
        "/",
        "(",
        "length",
        "*",
        "width",
        "*",
        "height",
        "*",
        "0.9",
        ")"
      ];
      double response = _compute.evaluateBracketExpression(input);
      expect(response, 100);
    });
  });

  group('evaluateBracketExpressionFailCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateBracketExpression should fail when invalid input is passed',
        () {
      List<String> input = [
        "cat",
        "/",
        "(",
        "length",
        "*",
        "width",
        "*",
        "height",
        "*",
        "0.9",
        ")"
      ];
      expect(
        () => _compute.evaluateBracketExpression(input),
        throwsA(
          isA<FormatException>(),
        ),
      );
    });
  });

  group('evaluateMathExpressionSuccessCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateMathExpression should succeed when valid input is passed',
        () {
      List<String> input = [
        "mass",
        "/",
        "(",
        "length",
        "*",
        "width",
        "*",
        "height",
        "*",
        "0.9",
        ")"
      ];
      double response = _compute.evaluateMathExpression(input);
      expect(response, 100);
    });
  });

  group('evaluateMathExpressionFailCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateMathExpression should fail when invalid input is passed', () {
      List<String> input = [
        "cat",
        "/",
        "(",
        "length",
        "*",
        "width",
        "*",
        "height",
        "*",
        "0.9",
        ")"
      ];
      expect(
        () => _compute.evaluateBracketExpression(input),
        throwsA(
          isA<FormatException>(),
        ),
      );
    });
  });

  group('evaluateIfSuccessCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateIf should succeed when valid input is passed', () {
      String input =
          "IIF(densityOption == 'specGravity', mass / ( length * width * height * 0.9 ), mass / ( length * width * height ) )";
      double response = _compute.evaluateIf(input);
      expect(response, 100);
    });
  });

  group('evaluateIfFailCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateIf should fail when invalid input is passed', () {
      String input =
          "IIF(densityOption == 'specGravity', cat / ( length * width * height * 0.9 ), mass / ( length * width * height ) )";
      expect(
        () => _compute.evaluateIf(input),
        throwsA(
          isA<FormatException>(),
        ),
      );
    });
  });

  group('evaluateExpSuccessCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateExp should succeed when valid input is passed', () {
      String input = "length * width * height";
      double response = _compute.evaluateExp(input);
      expect(response, 10.0);
    });
  });

  group('evaluateExpFailCase', () {
    test(
        'computeValues should return map when inputJsonAttribute, computeJsonAttribute is valid',
        () {
      List<Map<String, dynamic>> result =
          _compute.computeValues(inputJsonAttribute, computeJsonAttribute);
      expect(result, [
        {"name": "volume", "value": 10},
        {"name": "density", "value": 100}
      ]);
    });

    test('evaluateExp should fail when invalid input is passed', () {
      String input = "length * width * cat";
      expect(
        () => _compute.evaluateExp(input),
        throwsA(
          isA<FormatException>(),
        ),
      );
    });
  });
}
