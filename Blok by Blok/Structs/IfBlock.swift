import Foundation
import CoreTransferable

struct IfBlock: CodeBlockProtocol {
    let id: UUID
    var condition: String
    var nestedBlocks: [AnyCodeBlock]

    var codeStr: String {
        get {
            let nestedCode = nestedBlocks.map { $0.codeStr }.joined(separator: "\n    ")
            return "if \(condition) {\n    \(nestedCode)\n}"
        }
        set {
        }
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .codeBlock)
    }

    static func ==(lhs: IfBlock, rhs: IfBlock) -> Bool {
        return lhs.id == rhs.id && lhs.condition == rhs.condition && lhs.nestedBlocks == rhs.nestedBlocks
    }
}
