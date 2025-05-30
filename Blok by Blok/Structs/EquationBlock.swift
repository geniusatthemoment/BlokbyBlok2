import Foundation
import CoreTransferable

struct EquationBlock: CodeBlockProtocol {
    let id: UUID
    var variableId: UUID? = nil
    var assignedValue: String = ""
    var text: String

    var codeStr: String {
        get {
            return "\(text) = \(assignedValue);"
        }
        set {

        }
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .codeBlock)
    }

    static func ==(lhs: EquationBlock, rhs: EquationBlock) -> Bool {
        lhs.id == rhs.id &&
        lhs.variableId == rhs.variableId &&
        lhs.assignedValue == rhs.assignedValue
    }
}
