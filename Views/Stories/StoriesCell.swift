

import SwiftUI

struct StoriesCell: View {
    var stories: Stories
    let imageHeight: Double = 140
    let imageWidth: Double = 92
    @Environment(StoriesViewModel.self) private var viewModel
    var body: some View {
        ZStack(alignment: .leading){
            
            VStack(alignment: .leading) {
                Image(stories.previewImage)
                    .resizable()
                    .cornerRadius(16)
                    .frame(width: imageWidth, height: imageHeight)
                    .opacity(viewModel.isStoryViewed(stories) ? 0.5 : 1.0) // Затемнение для просмотренных
                     .overlay(
                         viewModel.isStoryViewed(stories) ?
                             RoundedRectangle(cornerRadius: 16)
                                 .stroke(Color.gray, lineWidth: 0) // Серая обводка для просмотренных
                             :
                             RoundedRectangle(cornerRadius: 16)
                                 .stroke(Color.blue, lineWidth: 4) // Синяя обводка для непросмотренных
                     )
            }
            VStack {
                Text("Text Text Text Text Text Text Text")
                    .font(.system(size: 12, weight: .regular))
                    .frame(width: 76, height: 45)
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    
                
            }
            .padding(.init(top: 83, leading: 0, bottom: 12, trailing: 8))
            
            .padding(.horizontal, 4)
          
            }
        .onTapGesture {
            if let index = viewModel.story.firstIndex(where: { $0.id == stories.id }) {
                viewModel.selectStory(at: index)
            }
        }
    }
}

#Preview {
    StoriesCell(stories: Stories(previewImage: "ConductorGirlPreview", images: ["ConductorGirlBig", "ConductorGirlTwoBig"]))
        .environment(StoriesViewModel())
}
