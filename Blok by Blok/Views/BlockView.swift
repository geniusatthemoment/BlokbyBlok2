import SwiftUI

// MARK: - Основная сцена
struct BlockView: View {
    let interpreter = Interpreter()
    
    @State private var output: String = ""
    @State private var codeBlocks: [AnyCodeBlock] = []
    @State private var showMenu = false
    @State private var selectedTab = 0

    @State private var newVariableBlock = AnyCodeBlock.variable(VariableBlock(id: UUID(), text: ""))
    @State private var newIfBlock = AnyCodeBlock.ifBlock(IfBlock(id: UUID(), condition: "", nestedBlocks: []))
    @State private var newPrintBlock = AnyCodeBlock.printBlock(PrintBlock(id: UUID(), text: ""))
    @State private var newEquationBlock = AnyCodeBlock.equationBlock(EquationBlock(id: UUID(), variableId: nil, assignedValue: "", text: ""))
    @State private var newArrayBlock = AnyCodeBlock.arrayBlock(ArrayBlock(id: UUID(), name: "", elementsText: ""))
    
    @State private var userVariables: [VariableBlock] = []
    
    func updateUserVariables() {
        userVariables = codeBlocks.compactMap {
            if case .variable(let varBlock) = $0 {
                return varBlock
            }
            return nil
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ZStack(alignment: .topLeading) {
                if showMenu {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation { showMenu = false }
                        }
                        .zIndex(1)
                }

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Spacer().frame(height: 70)
                        
                        ForEach(codeBlocks, id: \.id) { block in
                            BlockWrapperView(
                                block: binding(for: block),
                                parentBlocks: $codeBlocks,
                                newVariableBlock: $newVariableBlock,
                                newIfBlock: $newIfBlock,
                                newEquationBlock: $newEquationBlock,
                                userVariables: $userVariables,
                                newArrayBlock: $newArrayBlock
                            )
                            .draggable(block)
                        }
                        
                        Spacer().frame(height: 80)
                    }
                    .padding(.horizontal)
                }

                Button {
                    withAnimation { showMenu.toggle() }
                } label: {
                    Image(systemName: "sidebar.left")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.leading, 10)
                .padding(.top, 30)

                if showMenu {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Add Block")
                                .font(.headline)
                                .padding(.top, 40)
                            
                            Group {
                                BlockWrapperView(
                                    block: $newVariableBlock,
                                    parentBlocks: .constant([]),
                                    newVariableBlock: $newVariableBlock,
                                    newIfBlock: $newIfBlock,
                                    newEquationBlock: $newEquationBlock,
                                    userVariables: $userVariables,
                                    newArrayBlock: $newArrayBlock
                                )
                                .draggable(newVariableBlock)
                                
                                BlockWrapperView(
                                    block: $newIfBlock,
                                    parentBlocks: .constant([]),
                                    newVariableBlock: $newVariableBlock,
                                    newIfBlock: $newIfBlock,
                                    newEquationBlock: $newEquationBlock,
                                    userVariables: $userVariables,
                                    newArrayBlock: $newArrayBlock
                                )
                                .draggable(newIfBlock)
                                
                                BlockWrapperView(
                                    block: $newPrintBlock,
                                    parentBlocks: .constant([]),
                                    newVariableBlock: $newVariableBlock,
                                    newIfBlock: $newIfBlock,
                                    newEquationBlock: $newEquationBlock,
                                    userVariables: $userVariables,
                                    newArrayBlock: $newArrayBlock
                                )
                                .draggable(newPrintBlock)
                                BlockWrapperView(
                                    block: $newEquationBlock,
                                    parentBlocks: $codeBlocks,
                                    newVariableBlock: $newVariableBlock,
                                    newIfBlock: $newIfBlock,
                                    newEquationBlock: $newEquationBlock,
                                    userVariables: $userVariables,
                                    newArrayBlock: $newArrayBlock,
                                    isTemplate: true
                                )
                                .draggable(newEquationBlock)
                                
                                BlockWrapperView(
                                    block: $newArrayBlock,
                                    parentBlocks: $codeBlocks,
                                    newVariableBlock: $newVariableBlock,
                                    newIfBlock: $newIfBlock,
                                    newEquationBlock: $newEquationBlock,
                                    userVariables: $userVariables,
                                    newArrayBlock: $newArrayBlock,
                                    isTemplate: true
                                )
                                .draggable(newArrayBlock)
                            }
                            .frame(maxHeight: 400)
                        }
                        .padding()
                    }
                    .frame(width: 240)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
                }

                VStack {
                    Spacer()
                    Button(action: {
                        let combinedCode = codeBlocks.map { $0.codeStr }.joined(separator: "")
                        output = ""
                        interpreter.outputHandler = { line in
                            output += line + "\n"
                        }
                        interpreter.run(code: combinedCode)
                        selectedTab = 1
                    }) {
                        Label("Run", systemImage: "play.fill")
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.purple)
                            .clipShape(Capsule())
                            .shadow(radius: 4)
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal)
                }
            }
            .tag(0)
            .onChange(of: codeBlocks) { _ in updateUserVariables() }
            .dropDestination(for: AnyCodeBlock.self) { items, _ in
                guard let block = items.first else { return false }
                if let index = codeBlocks.firstIndex(where: { $0.id == block.id }) {
                    let moved = codeBlocks.remove(at: index)
                    codeBlocks.append(moved)
                } else {
                    switch block {
                    case .variable(let v):
                        let newBlock = VariableBlock(id: UUID(), text: v.text)
                        codeBlocks.append(.variable(newBlock))
                        newVariableBlock = .variable(VariableBlock(id: UUID(), text: ""))
                    case .ifBlock(let i):
                        let newBlock = IfBlock(id: UUID(), condition: i.condition, nestedBlocks: i.nestedBlocks)
                        codeBlocks.append(.ifBlock(newBlock))
                        newIfBlock = .ifBlock(IfBlock(id: UUID(), condition: "", nestedBlocks: []))
                    case .printBlock(let p):
                        let newBlock = PrintBlock(id: UUID(), text: p.text)
                        codeBlocks.append(.printBlock(newBlock))
                        newPrintBlock = .printBlock(PrintBlock(id: UUID(), text: ""))
                    case .equationBlock(let e):
                        let newBlock = EquationBlock(id: UUID(), variableId: e.variableId, assignedValue: e.assignedValue, text: e.text)
                        codeBlocks.append(.equationBlock(newBlock))
                        newEquationBlock = .equationBlock(EquationBlock(id: UUID(), variableId: nil, assignedValue: "", text: ""))
                    case .arrayBlock(let a):
                        let newBlock = ArrayBlock(id: UUID(), name: a.name, elementsText: a.elementsText)
                        codeBlocks.append(.arrayBlock(newBlock))
                        newArrayBlock = .arrayBlock(ArrayBlock(id: UUID(), name: "", elementsText: ""))
                    }
                }
                return true
            }
            
            .tabItem {
                Label("Blocks", systemImage: "square.grid.2x2")
            }
            ConsoleView(output: output)
                .tabItem {
                    Label("Console", systemImage: "terminal")
                }
                .tag(1)
        }
    }
    private func binding(for block: AnyCodeBlock) -> Binding<AnyCodeBlock> {
        guard let index = codeBlocks.firstIndex(where: { $0.id == block.id }) else {
            fatalError("Block not found")
        }
        return $codeBlocks[index]
    }
    
}
