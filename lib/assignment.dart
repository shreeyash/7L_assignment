List<Map<String, dynamic>> inputAttributesJson = [
  {"name": "mass", "type": "number", "value": 900},
  {"name": "length", "type": "number", "value": 2},
  {"name": "width", "type": "number", "value": 1},
  {"name": "height", "type": "number", "value": 5},
  {"name": "densityOption", "type": "string", "value": "specGravity"}
];

List<Map<String, dynamic>> computedAttributesJson = [
  {"name": "volume", "expression": "length * width * height"},
  {
    "name": "density",
    "expression":
        "IIF(densityOption == 'specGravity', mass/(length * width * height * 0.9), mass / (length * width * height))"
  }
];

Map<String, dynamic> variableTypes = {};
Map<String, dynamic> variableValues = {};

void main() {
  inputAttributesJson.forEach(
    (element) {
      variableValues.addAll(
        {element['name']: element['value']},
      );
    },
  );

  print(variableValues);

  inputAttributesJson.forEach(
    (element) {
      variableTypes.addAll(
        {element['name']: element['type']},
      );
    },
  );

  print(variableTypes);

  bool expressionState = evaluateIf(
      "IIF(densityOption == 'specGravity', mass/(length * width * height * 0.9), mass / (length * width * height))");
  print("Expression State - $expressionState");
}

// This functions evaluates the IIF condition
bool evaluateIf(String exp) {
  bool isConditionTrue;
  double exp1;
  double exp2;
  String trimmedExpression = exp.trim();
  var startIndex = trimmedExpression.indexOf('(');
  var lastIndex = trimmedExpression.lastIndexOf(')');
  trimmedExpression =
      trimmedExpression.substring(startIndex + 1, lastIndex).trim();
  var expList = trimmedExpression.split(",");
  isConditionTrue = evaluateLogicExpression(expList[0]);
  evaluateMathExpression(expList[1].trim().split(' '));
  print("Expression 1 - ${expList[1].trim().split(' ')}");
  print("Expression 2 - ${expList[2].trim().split(' ')}");
  return isConditionTrue;
//         if (isConditionTrue) {
//             return exp1;
//         } else {
//             return exp2;
//         }
}

dynamic evaluateMathExpression(List<String> expression) {
  var result = 0.00;
  String operator;
  print("Expression - $expression");

  


  if (expression.contains('(')) {
    print('Expression contains (');
    result = evaluateBracketExpression(expression);
  } else {
    print("Inside else");
    for (var i = 0; i < expression.length; i++) {
      print("Expression of i - ${variableValues[expression[i]]}");
      var expressionValue =
          variableValues[expression[i]] == null && expression[i].length > 1
              ? expression[i]
              : variableValues[expression[i]] ?? 1.0;

      print("Expression value - $expressionValue");

      switch (expression[i]) {
        case '+':
          operator = '+';
          break;
        case '-':
          operator = '-';
          break;
        case '*':
          operator = '*';
          break;
        case '/':
          operator = '/';
          break;
        default:
          print("Default case");
          if (operator == null) {
            result = double.parse(expressionValue) * 1.0;
          } else {
            print("else default case");
          }
      }
    }
  }
  return result;
}

evaluateBracketExpression(List<String> expression) {
  print("Inside evaluateBracketExpression");
  int startIndex;
  int endIndex;
  double evaluateSubExpression;
  for (var i = 0; i < expression.length; i++) {
    if (expression[i] == '(') {
      startIndex = i;
    } else if (expression[i] == ')') {
      endIndex = i;
      break;
    }
  }
  // evaluating the contents of the bracket.
  print("evaluating the contents of the bracket");
  evaluateSubExpression = evaluateMathExpression(
      expression.getRange(startIndex + 1, endIndex).toList());
  print(
      'From Evaluate Bracket Exp: evaluateSubExpression or result : $evaluateSubExpression');
  // replacing brackets in array by evaluateSubExpression value
  expression.replaceRange(
      startIndex, endIndex + 1, [evaluateSubExpression.toString()]);

  print('From Evaluate Bracket Exp: evaluateSubExpression :  $expression');
  // evaluating the new array again, by calling it recrusively
  return evaluateMathExpression(expression);
}

/// This functions evaluates logical expression as true or false
bool evaluateLogicExpression(String expression) {
  var rightExp;
  List<String> operands;
  bool result;
  operands = expression.split(' ');
  operands[2] = operands[2].substring(1, operands[2].length - 1).trim();
  if (variableTypes[operands[0]] == "number") {
    rightExp = double.parse(operands[2]);
  } else {
    rightExp = operands[2];
  }
  switch (operands[1]) {
    case "==":
      result = variableValues[operands[0]] == rightExp;
      break;
    case "<":
      result = variableValues[operands[0]] < rightExp;
      break;
    case ">":
      result = variableValues[operands[0]] > rightExp;
      break;
    case "!=":
      result = variableValues[operands[0]] != rightExp;
      break;
    case "<=":
      result = variableValues[operands[0]] <= rightExp;
      break;
    case ">=":
      result = variableValues[operands[0]] >= rightExp;
      break;
    default:
      result = true;
  }
  print("Log Exp result: {} - $result");
  return result;
}
