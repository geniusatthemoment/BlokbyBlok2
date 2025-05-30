
import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.purple)
            
            VStack {
                VStack(spacing:3) {
                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 300, height: 90)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .offset(x:-30)
                        Text(LocalizedStringKey("first_blok_text"))
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(Color.purple)
                            .offset(x:-30)
                    }
                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 300, height: 90)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                        Text(LocalizedStringKey("second_blok_text"))
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(Color.purple)
                            .offset(x:10)
                    }
                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 300, height: 90)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .offset(x:30)
                        Text(LocalizedStringKey("third_blok_text"))
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(Color.purple)
                            .offset(x:20)
                    }
                    
                }
                .padding(.top, 90)
                VStack(spacing: 8) {
                    Text(LocalizedStringKey("name"))
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: 70))
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .frame(height: 550)
        }
        .ignoresSafeArea(edges: .top)
    }
}

