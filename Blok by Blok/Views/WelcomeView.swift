import SwiftUI
import Security

struct WelcomeView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var codeBlocks: [AnyCodeBlock] = []
    @State private var consoleOutput: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                HeaderView()
                Spacer()
                NavigationLink(destination: BlockView()) {
                    Text("Start!")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(12)
                        .font(.system(size: 40, weight: .semibold))
                }
                .padding(.horizontal, 40)
                
                Text("Learn code the fun way!")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.bottom,90)

            }
            .frame(maxWidth: .infinity)
        }
    }
}

