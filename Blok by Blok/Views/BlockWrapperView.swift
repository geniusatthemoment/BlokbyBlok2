import SwiftUI
extension String {
    var splitCode: (type: String, value: String) {
        let parts = self.split(separator: "/", maxSplits: 1).map(String.init)
        if parts.count == 2 {
            return (parts[0], parts[1])
        } else if parts.count == 1 {
            return (parts[0], "")
        } else {
            return ("String", "")
        }
    }
}
struct BlockWrapperView: View {
    @Binding var block: AnyCodeBlock
    @Binding var parentBlocks: [AnyCodeBlock]
    @Binding var newVariableBlock: AnyCodeBlock
    @Binding var newIfBlock: AnyCodeBlock
    @Binding var newEquationBlock: AnyCodeBlock
    @Binding var userVariables: [VariableBlock]
    @Binding var newArrayBlock: AnyCodeBlock
    
    var isTemplate: Bool = false
    

    var body: some View {
        switch block {
        case .variable:
            VariableView(block: $block, userVariables: $userVariables) {
                if let index = parentBlocks.firstIndex(where: { $0.id == block.id }) {
                    parentBlocks.remove(at: index)
                    }
                }

        case .ifBlock:
            IfBlockView(
                block: $block,
                parentBlocks: $parentBlocks,
                newVariableBlock: $newVariableBlock,
                newIfBlock: $newIfBlock,
                newEquationBlock: $newEquationBlock,
                userVariables: $userVariables,
                newArrayBlock: $newArrayBlock,
                onDelete: {
                    if let index = parentBlocks.firstIndex(where: { $0.id == block.id }) {
                        parentBlocks.remove(at: index)
                        }
                }
            )
        case .printBlock:
            PrintBlockView(block: $block) {
                if let index = parentBlocks.firstIndex(where: { $0.id == block.id }) {
                    parentBlocks.remove(at: index)
                }
            }
        case .equationBlock:
            EquationBlockView(
                block: $block,
                userVariables: $userVariables,
                onDelete: {
                    if let index = parentBlocks.firstIndex(where: { $0.id == block.id }) {
                        parentBlocks.remove(at: index)
                    }
                }
            )
            .opacity(isTemplate ? 0.5 : 1.0)
        case .arrayBlock:
            ArrayBlockView(block: $block) {
                if let index = parentBlocks.firstIndex(where: { $0.id == block.id }) {
                    parentBlocks.remove(at: index)
                }
            }
                
        }
    }
}
