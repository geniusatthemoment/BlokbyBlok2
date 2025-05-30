import SwiftUI

struct EquationBlockView: View {
    @Binding var block: AnyCodeBlock
    @Binding var userVariables: [VariableBlock]
    var onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                HStack(spacing: 10) {
                    Picker(selection: Binding(
                        get: {
                            if case .equationBlock(let eq) = block {
                                return eq.variableId ?? UUID()
                            }
                            return UUID()
                        },
                        set: { newId in
                            if case .equationBlock(var eq) = block {
                                eq.variableId = newId
                                
                                if let selectedVariable = userVariables.first(where: { $0.id == newId }) {
                                    eq.text = selectedVariable.text
                                }

                                block = .equationBlock(eq)
                            }
                        }
                    ), label: Text("")) {
                        Text("Var").tag(UUID())
                        ForEach(userVariables) { variable in
                            Text(variable.text).tag(variable.id)
                        }
                    }
                    .frame(width: 100)
                    .clipped()
                    .labelsHidden()
                    .pickerStyle(MenuPickerStyle())

                    Text("=")

                    TextField("Value", text: Binding(
                        get: {
                            if case .equationBlock(let eq) = block {
                                return eq.assignedValue
                            }
                            return ""
                        },
                        set: { newVal in
                            if case .equationBlock(var eq) = block {
                                eq.assignedValue = newVal
                                block = .equationBlock(eq)
                            }
                        }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 80)
                }
            }
            .padding(8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                    .padding(6)
            }
        }
    }
}
