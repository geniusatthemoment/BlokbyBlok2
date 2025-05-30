class Interpreter {
    private var variables: [String: Int] = [:]
    var outputHandler: ((String) -> Void)?
    private var hadError = false

    func run(code: String) {
        variables = [:]
        hadError = false
        let cleanedCode = code
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
            .replacingOccurrences(of: "\n", with: " ")
        let tokens = tokenize(cleanedCode)
        parse(tokens)
    }

    private func tokenize(_ input: String) -> [String] {
        var tokens: [String] = []
        var current = ""
        let singleCharOperators = Set("+-*/%()=;{}<>!")
        var i = input.startIndex

        while i < input.endIndex {
            let char = input[i]

            if char.isWhitespace {
                if !current.isEmpty {
                    tokens.append(current)
                    current = ""
                }
                i = input.index(after: i)
            } else if char == "\"" {
                if !current.isEmpty {
                    tokens.append(current)
                    current = ""
                }
                var stringLiteral = "\""
                i = input.index(after: i)
                while i < input.endIndex && input[i] != "\"" {
                    stringLiteral.append(input[i])
                    i = input.index(after: i)
                }
                if i < input.endIndex {
                    stringLiteral.append("\"")
                    i = input.index(after: i)
                }
                tokens.append(stringLiteral)
            } else if singleCharOperators.contains(char) {
                if !current.isEmpty {
                    tokens.append(current)
                    current = ""
                }
                if char == "=" || char == "!" || char == "<" || char == ">" {
                    let nextIndex = input.index(after: i)
                    if nextIndex < input.endIndex {
                        let nextChar = input[nextIndex]
                        if nextChar == "=" {
                            tokens.append(String(char) + String(nextChar))
                            i = input.index(i, offsetBy: 2)
                            continue
                        }
                    }
                }
                tokens.append(String(char))
                i = input.index(after: i)
            } else {
                current.append(char)
                i = input.index(after: i)
            }
        }

        if !current.isEmpty {
            tokens.append(current)
        }
        return tokens
    }

    private func parse(_ tokens: [String]) {
        var index = 0

        func next() -> String? {
            guard index < tokens.count else { return nil }
            let token = tokens[index]
            index += 1
            return token
        }

        func peek() -> String? {
            guard index < tokens.count else { return nil }
            return tokens[index]
        }

        while let token = next(), !hadError {
            if token == "print" {
                _ = next()
                var exprTokens: [String] = []
                var parenCount = 1
                while parenCount > 0, let tok = next() {
                    if tok == "(" { parenCount += 1 }
                    else if tok == ")" { parenCount -= 1 }
                    if parenCount > 0 { exprTokens.append(tok) }
                }
                if hadError { return }
                if exprTokens.count == 1, exprTokens[0].hasPrefix("\"") {
                    let stringLiteral = exprTokens[0]
                    let unquoted = String(stringLiteral.dropFirst().dropLast())
                    outputHandler?(unquoted)
                } else {
                    let value = evaluateExpression(exprTokens)
                    if hadError { return }
                    outputHandler?("\(value)")
                }
                _ = next()
            } else if token == "if" {
                var conditionTokens: [String] = []
                while let tok = peek(), tok != "{" {
                    conditionTokens.append(next()!)
                }
                _ = next()
                var blockTokens: [String] = []
                var braceCount = 1
                while braceCount > 0, let tok = next() {
                    if tok == "{" { braceCount += 1 }
                    else if tok == "}" { braceCount -= 1 }
                    if braceCount > 0 { blockTokens.append(tok) }
                }
                let conditionValue = evaluateExpression(conditionTokens)
                if hadError { return }
                if conditionValue != 0 {
                    parse(blockTokens)
                    if hadError { return }
                }
            } else if let nextToken = peek(), nextToken == "=" {
                _ = next()
                var exprTokens: [String] = []
                while let tok = peek(), tok != ";" {
                    exprTokens.append(next()!)
                }
                _ = next()
                assign(name: token, exprTokens: exprTokens)
                if hadError { return }
            } else if token == ";" {
                continue
            } else {
                if peek() == ";" {
                    variables[token] = 0
                    _ = next()
                } else {
                    error("Unknown command or variable: \(token)", index)
                    return
                }
            }
        }
    }

    private func assign(name: String, exprTokens: [String]) {
        let result = evaluateExpression(exprTokens)
        if hadError { return }
        variables[name] = result
    }

    private func evaluateExpression(_ tokens: [String]) -> Int {
        var index = 0

        func parseExpression() -> Int {
            var left = parseTerm()
            while index < tokens.count {
                let op = tokens[index]
                if op == "+" || op == "-" {
                    index += 1
                    let right = parseTerm()
                    if op == "+" { left += right }
                    else { left -= right }
                } else {
                    break
                }
            }
            return left
        }

        func parseTerm() -> Int {
            var left = parseFactor()
            while index < tokens.count {
                let op = tokens[index]
                if op == "*" || op == "/" || op == "%" {
                    index += 1
                    let right = parseFactor()
                    switch op {
                    case "*": left *= right
                    case "/": left = right != 0 ? left / right : 0
                    case "%": left = right != 0 ? left % right : 0
                    default: break
                    }
                } else {
                    break
                }
            }
            return left
        }

        func parseFactor() -> Int {
            if index >= tokens.count { return 0 }
            let token = tokens[index]
            index += 1

            if token == "(" {
                let val = parseFullExpression()
                if index < tokens.count && tokens[index] == ")" {
                    index += 1
                }
                return val
            } else if let number = Int(token) {
                return number
            } else if let varVal = variables[token] {
                return varVal
            } else {
                error("Cannot find \(token) in this scope", index)
                return 0
            }
        }

        func parseFullExpression() -> Int {
            let left = parseExpression()
            if index < tokens.count {
                let op = tokens[index]
                if ["==", "!=", "<", ">", "<=", ">="].contains(op) {
                    index += 1
                    let right = parseExpression()
                    switch op {
                    case "==": return left == right ? 1 : 0
                    case "!=": return left != right ? 1 : 0
                    case "<":  return left < right ? 1 : 0
                    case ">":  return left > right ? 1 : 0
                    case "<=": return left <= right ? 1 : 0
                    case ">=": return left >= right ? 1 : 0
                    default: return 0
                    }
                }
            }
            return left
        }

        return parseFullExpression()
    }

    private func error(_ message: String, _ index: Int) {
        if !hadError {
            hadError = true
            outputHandler?("Error: \(message)")
        }
    }
}
