import Foundation
import CoreTransferable

struct ArrayBlock: CodeBlockProtocol {
    let id: UUID
    var name: String
    var elementsText: String

    var codeStr: String {
        get {
            let cleaned = elementsText
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .joined(separator: ", ")
            return "\(name) = [\(cleaned)];"
        }
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .codeBlock)
    }

    static func ==(lhs: ArrayBlock, rhs: ArrayBlock) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.elementsText == rhs.elementsText
    }
}
