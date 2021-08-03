import 'package:sevenlake_assignment/compute.dart';

void main() {
  Compute _compute = Compute();

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
  List<Map<String, dynamic>> result =
      _compute.computeValues(inputJsonAttribute, computeJsonAttribute);

  print(result);
}
