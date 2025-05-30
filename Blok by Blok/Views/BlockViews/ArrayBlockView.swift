import SwiftUI

struct ArrayBlockView: View {
    @Binding var block: AnyCodeBlock
    var onDelete: () -> Void

    var body: some View {
        if case .arrayBlock(var arrayBlock) = block {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Array (Int)").bold()

                    TextField("Name", text: Binding(
                        get: { arrayBlock.name },
                        set: {
                            arrayBlock.name = $0
                            block = .arrayBlock(arrayBlock)
                        }
                    ))

                    TextField("Values (comma separated)", text: Binding(
                        get: { arrayBlock.elementsText },
                        set: {
                            arrayBlock.elementsText = $0
                            block = .arrayBlock(arrayBlock)
                        }
                    ))
                }
                .padding()
                .background(Color.orange.opacity(0.3))
                .cornerRadius(10)

                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                        .padding(6)
                }
            }
        }
    }
}
