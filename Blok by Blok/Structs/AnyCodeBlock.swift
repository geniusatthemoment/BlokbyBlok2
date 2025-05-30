import SwiftUI
import UniformTypeIdentifiers

enum AnyCodeBlock: Identifiable, Codable, Transferable, Equatable {
    case variable(VariableBlock)
    case ifBlock(IfBlock)
    case printBlock(PrintBlock)
    case equationBlock(EquationBlock)
    case arrayBlock(ArrayBlock)
    
    var id: UUID {
        switch self {
        case .variable(let block): return block.id
        case .ifBlock(let block): return block.id
        case .printBlock(let block): return block.id
        case .equationBlock(let block): return block.id
        case .arrayBlock(let block): return block.id
        }
    }
    
    var codeStr: String {
        get {
            switch self {
            case .variable(let b): return b.codeStr
            case .ifBlock(let b): return b.codeStr
            case .printBlock(let b): return b.codeStr
            case .equationBlock(let b): return b.codeStr
            case .arrayBlock(let b): return b.codeStr
            }
        }
        set {
            switch self {
            case .variable(var b):
                b.codeStr = newValue
                self = .variable(b)
            case .ifBlock(var b):
                b.codeStr = newValue
                self = .ifBlock(b)
            case .printBlock(var b):
                b.codeStr = newValue
                self = .printBlock(b)
            case .equationBlock(var b):
                b.codeStr = newValue
                self = .equationBlock(b)
            case .arrayBlock(var b):
                b.codeStr = newValue
                self = .arrayBlock(b)
            }
        }
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .codeBlock)
    }
    
    static func ==(lhs: AnyCodeBlock, rhs: AnyCodeBlock) -> Bool {
        switch (lhs, rhs) {
        case (.variable(let l), .variable(let r)): return l == r
        case (.ifBlock(let l), .ifBlock(let r)): return l == r
        case (.printBlock(let l), .printBlock(let r)): return l == r
        case (.equationBlock(let l), .equationBlock(let r)): return l == r
        case (.arrayBlock(let l), .arrayBlock(let r)): return l == r
        default: return false
        }
    }
}

extension UTType {
    static let codeBlock = UTType(exportedAs: "co.codeBlock")
}

