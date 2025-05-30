import Foundation
import CoreTransferable

struct VariableBlock: CodeBlockProtocol {
    let id: UUID
    var text: String

    var codeStr: String {
        get { "\(text);" }
        set {
//            let parts = newValue.split(separator: "/")
//            if parts.count == 2 {
//                self.text = String(parts[1])
//            } else {
//                print("Warning: Invalid codeStr format '\(newValue)' for VariableBlock")
//                self.text = ""
//            }
        }
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .codeBlock)
    }

    static func ==(lhs: VariableBlock, rhs: VariableBlock) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text
    }
}
