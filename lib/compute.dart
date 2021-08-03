class Compute {
  Map<String, dynamic> variableValues;
  Map<String, dynamic> variableTypes;

// evaluateBracketExpression is a recrusive function and it evaluates the Bracket expression, takes List of String expressions as an argument,
// eg: [mass, /, (, length, *, width, *, height, *, 0.9, )]
// and evaluate if the list has bracket ( , ) or not and accordingly at the start and end index
// to calculate values for the particular expression which lies inside bracket by calling evaluateMathExpression as and when needed.
  double evaluateBracketExpression(List<String> expressionValue) {
    print('From Bracket Math Exp: Input = $expressionValue');
    int startIndex;
    int endIndex;
    double subExpressionValue;
    for (var i = 0; i < expressionValue.length; i++) {
      if (expressionValue[i] == '(') {
        startIndex = i;
      } else if (expressionValue[i] == ')') {
        endIndex = i;
        break;
      }
    }
    subExpressionValue = evaluateMathExpression(
        expressionValue.getRange(startIndex + 1, endIndex).toList());
    print(
        'From Evaluate Bracket Exp: subExpValue or result = $subExpressionValue');
    expressionValue.replaceRange(
        startIndex, endIndex + 1, [subExpressionValue.toString()]);
    print('From Evaluate Bracket Exp: subExpList =  $expressionValue');
    return evaluateMathExpression(expressionValue);
  }

// evaluateMathExpression function evaluates the Mathematical expression, takes List of String expressions as an argument,
// eg. mass, /, (, length, *, width, *, height, *, 0.9, )
// and evaluate all the possible mathematical operator conditions(+ , - , * , / ),
// and calculates the value based on the given operator and returns the calculated value of it.
  double evaluateMathExpression(List<String> expressionValue) {
    print('From Evaluate Math Exp: Input = $expressionValue');
    String operator;
    var result = 0.0;
    if (expressionValue.contains('(')) {
      result = evaluateBracketExpression(expressionValue);
    } else {
      for (var i = 0; i < expressionValue.length; i++) {
        var value = variableValues[expressionValue[i]] == null &&
                expressionValue[i].length > 1
            ? double.parse(expressionValue[i])
            : variableValues[expressionValue[i]] ??
                double.tryParse(expressionValue[i]);
        switch (expressionValue[i]) {
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
            if (operator == null) {
              result = value * 1.0;
            } else {
              switch (operator) {
                case '+':
                  result = result + value;
                  operator = null;
                  break;
                case '-':
                  result = result - value;
                  operator = null;
                  break;
                case '*':
                  result = result * value;
                  operator = null;
                  break;
                case '/':
                  result = result / value;
                  operator = null;
                  break;
                default:
                  result = result;
                  operator = null;
              }
            }
        }
      }
    }
    return result;
  }

// evaluateLogicExpression function evaluates the Logical expression, takes String expression as an argument,
// and evaluate all the possible logical conditions(== , > , < , >= , <=, !=),
// which returns boolean value based on the different conditions
  bool evaluateLogicExpression(String expression) {
    var value;
    List<String> operands;
    bool result;
    operands = expression.split(' ');
    print('From evaluateLogExp $operands');
    operands[2] = operands[2].substring(1, operands[2].length - 1).trim();
    if (variableTypes[operands[0]] == 'number') {
      value = double.parse(operands[2]);
    } else {
      value = operands[2];
    }
    switch (operands[1]) {
      case '==':
        result = variableValues[operands[0]] == value;
        break;
      case '>':
        result = variableValues[operands[0]] > value;
        break;
      case '<':
        result = variableValues[operands[0]] < value;
        break;
      case '>=':
        result = variableValues[operands[0]] >= value;
        break;
      case '<=':
        result = variableValues[operands[0]] <= value;
        break;
      case '!=':
        result = variableValues[operands[0]] != value;
        break;
      default:
        result = false;
    }
    print('From Evaluate Log Exp result = $result');
    return result;
  }

// evaluateIf function evaluates the If expression, takes String expression as an argument,
// and evaluate the possible logical conditions(function - evaluateLogicExpression),
// which returns boolean value, if it's true, calcualtes the math expression of 1st argument else
// calcualtes the math expression of 2nd argument
  double evaluateIf(String expression) {
    bool isConditionTrue;
    String trimmedExpression = expression.trim();
    var startIndex = trimmedExpression.indexOf('(');
    var lastIndex = trimmedExpression.lastIndexOf(')');
    trimmedExpression =
        trimmedExpression.substring(startIndex + 1, lastIndex).trim();
    var expressionList = trimmedExpression.split(",");
    isConditionTrue = evaluateLogicExpression(expressionList[0]);
    evaluateMathExpression(expressionList[1].trim().split(' '));
    if (isConditionTrue) {
      return evaluateMathExpression(expressionList[1].trim().split(' '));
    } else {
      return evaluateMathExpression(expressionList[2].trim().split(' '));
    }
  }

// evaluateExp function will evaluate the expression, takes String expression as an argument,
// if it's IIF Expression, it calls evaluateIf otherwise evaluateMathExpression
// and returns the result returned from the functions being called.
  double evaluateExp(String expression) {
    double result;
    if (expression.contains('IIF')) {
      result = evaluateIf(expression);
    } else {
      result = evaluateMathExpression(expression.trim().split(' '));
    }
    print("evaluateExp - $result");
    return result;
  }

  List<Map<String, dynamic>> computeValues(
      List<Map<String, dynamic>> inputJsonAttribute,
      List<Map<String, dynamic>> computeJsonAttribute) {
    List<Map<String, dynamic>> resultMap;
    resultMap = [];
    variableValues = {};
    inputJsonAttribute.forEach((element) {
      variableValues?.addAll(
        {element['name']: element['value']},
      );
    });
    variableTypes = {};
    inputJsonAttribute.forEach((element) {
      variableTypes?.addAll(
        {element['name']: element['type']},
      );
    });
    computeJsonAttribute.forEach((Map<String, dynamic> value) {
      Map<String, dynamic> resultValue;
      resultValue = {
        'name': value['name'],
        'value': evaluateExp(value['expression']),
      };
      resultMap.add(resultValue);
    });
    return resultMap;
  }
}
