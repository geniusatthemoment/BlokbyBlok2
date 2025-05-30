import SwiftUI

struct IfBlockView: View {
    @Binding var block: AnyCodeBlock
    @Binding var parentBlocks: [AnyCodeBlock]
    @Binding var newVariableBlock: AnyCodeBlock
    @Binding var newIfBlock: AnyCodeBlock
    @Binding var newEquationBlock: AnyCodeBlock
    @Binding var userVariables: [VariableBlock]
    @Binding var newArrayBlock : AnyCodeBlock
    
    
    var onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("If:")
                    TextField("Condition", text: Binding(
                        get: {
                            if case .ifBlock(let b) = block { return b.condition }
                            return ""
                        },
                        set: { newValue in
                            if case .ifBlock(var b) = block {
                                b.condition = newValue
                                block = .ifBlock(b)
                            }
                        }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                if case .ifBlock(let ifBlock) = block {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(ifBlock.nestedBlocks, id: \.id) { nestedBlock in
                            BlockWrapperView(
                                block: nestedBinding(for: nestedBlock),
                                parentBlocks: nestedParentBinding(),
                                newVariableBlock: $newVariableBlock,
                                newIfBlock: $newIfBlock,
                                newEquationBlock: $newEquationBlock,
                                userVariables: $userVariables,
                                newArrayBlock: $newArrayBlock
                            )
                            .draggable(nestedBlock)
                            .padding(.leading, 20)
                        }
                    }
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
                }
            }
            .padding()
            .background(Color.purple)
            .cornerRadius(8)
            .shadow(radius: 1)
            .dropDestination(for: AnyCodeBlock.self) { items, _ in
                guard let droppedBlock = items.first else { return false }
                
                guard case .ifBlock(var ifBlock) = block else { return false }

                if droppedBlock.id != newVariableBlock.id &&
                   droppedBlock.id != newIfBlock.id {
                    if let index = parentBlocks.firstIndex(where: { $0.id == droppedBlock.id }) {
                        parentBlocks.remove(at: index)
                    }
                }

                if let index = ifBlock.nestedBlocks.firstIndex(where: { $0.id == droppedBlock.id }) {
                    ifBlock.nestedBlocks.remove(at: index)
                }
                
                ifBlock.nestedBlocks.append(droppedBlock)

                block = .ifBlock(ifBlock)
                
                return true
            }


            Button(action: {
                onDelete()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                    .padding(6)
            }
        }
    }

    private func nestedBinding(for nestedBlock: AnyCodeBlock) -> Binding<AnyCodeBlock> {
        guard case .ifBlock(var ifBlock) = block else {
            fatalError("Not an IfBlock")
        }
        guard let index = ifBlock.nestedBlocks.firstIndex(where: { $0.id == nestedBlock.id }) else {
            fatalError("Nested block not found")
        }
        return Binding(
            get: { ifBlock.nestedBlocks[index] },
            set: { newValue in
                ifBlock.nestedBlocks[index] = newValue
                block = .ifBlock(ifBlock)
            }
        )
    }

    private func nestedParentBinding() -> Binding<[AnyCodeBlock]> {
        Binding(
            get: {
                if case .ifBlock(let ifBlock) = block {
                    return ifBlock.nestedBlocks
                }
                return []
            },
            set: { newValue in
                if case .ifBlock(var ifBlock) = block {
                    ifBlock.nestedBlocks = newValue
                    block = .ifBlock(ifBlock)
                }
            }
        )
    }
}
