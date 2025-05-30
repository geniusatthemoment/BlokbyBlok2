import Foundation
import CoreTransferable

protocol CodeBlockProtocol: Identifiable, Codable, Transferable, Equatable {
    var id: UUID { get }
    var codeStr: String { get set}
}
