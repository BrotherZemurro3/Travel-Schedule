
import SwiftUI

struct NoInternetView: View {
    @Binding var navigationPath: NavigationPath
    

    
    
    var body: some View {

        VStack{
            Spacer()
            
            Image("NoInternet")
                .resizable()
                .scaledToFit()
                .frame(width: 233, height: 233)
                .foregroundStyle(.grayUniversal)
            
            
            Text("Нет интернета")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.blackDay)
                .padding(.top, 16)
                Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            navigationPath.removeLast()
        }) {
            Image(systemName: "chevron.left")
                .foregroundStyle(.blackDay)
        })
    }
}


#Preview {
    NoInternetView(navigationPath: .constant(NavigationPath()))
}
