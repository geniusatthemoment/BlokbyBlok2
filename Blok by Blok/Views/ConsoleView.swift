import SwiftUI

struct ConsoleView: View {
    let output: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Console Output")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 8)

                Text(output.isEmpty ? "Nothing to show yet." : output)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
