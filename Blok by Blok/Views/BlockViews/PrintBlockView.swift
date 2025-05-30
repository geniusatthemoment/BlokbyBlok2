import SwiftUI

struct PrintBlockView: View {
    @Binding var block: AnyCodeBlock
    var onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                Text("Print:")
                TextField("Text", text: bindingText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .background(Color.pink.opacity(0.2))
            .cornerRadius(10)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                    .padding(6)
            }
        }
    }

    private var bindingText: Binding<String> {
        Binding<String>(
            get: {
                if case .printBlock(let b) = block {
                    return b.text
                }
                return ""
            },
            set: { newValue in
                if case .printBlock(var b) = block {
                    b.text = newValue
                    block = .printBlock(b)
                }
            }
        )
    }
}

