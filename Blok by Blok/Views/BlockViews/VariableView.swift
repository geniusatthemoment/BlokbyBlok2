import SwiftUI

struct VariableView: View {
    @Binding var block: AnyCodeBlock
    @Binding var userVariables: [VariableBlock]
    var onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 10) {
                TextField("Value", text: Binding(
                    get: {
                        if case .variable(let b) = block { return b.text }
                        return ""
                    },
                    set: { newValue in
                        if case .variable(var b) = block {
                            b.text = newValue
                            block = .variable(b)
                            updateUserVariables(with: b)
                        }
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 1)

            Button(action: {
                onDelete()
                removeFromUserVariables()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                    .padding(6)
            }
        }
        .onAppear {
            if case .variable(let b) = block {
                updateUserVariables(with: b)
            }
        }
    }

    private func updateUserVariables(with variable: VariableBlock) {
        if let index = userVariables.firstIndex(where: { $0.id == variable.id }) {
            userVariables[index] = variable
        } else {
            userVariables.append(variable)
        }
    }

    private func removeFromUserVariables() {
        guard !userVariables.isEmpty else { return }

        if case .variable(let b) = block {
            if let index = userVariables.firstIndex(where: { $0.id == b.id }) {
                userVariables.remove(at: index)
            }
        }
    }
}
