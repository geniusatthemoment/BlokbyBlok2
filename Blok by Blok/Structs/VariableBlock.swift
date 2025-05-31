import Foundation
import CoreTransferable

struct VariableBlock: CodeBlockProtocol {
    let id: UUID
    var text: String

    var codeStr: String {
        get { "\(text);" }
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .codeBlock)
    }

    static func ==(lhs: VariableBlock, rhs: VariableBlock) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text
    }
}
