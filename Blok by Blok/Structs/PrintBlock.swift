import Foundation
import CoreTransferable

struct PrintBlock: CodeBlockProtocol {
    var id: UUID
    var text: String
    var codeStr: String{
        get { return "print (\(text));" }
    }
    static var transferRepresentation: some TransferRepresentation {
            CodableRepresentation(contentType: .codeBlock)
        }
    static func ==(lhs: PrintBlock, rhs: PrintBlock) -> Bool {
        lhs.id == rhs.id && lhs.codeStr == rhs.codeStr
    }
}
