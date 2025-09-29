

import SwiftUI


struct AsyncImageView: View {
    let url: String?
    let placeholder: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    @State private var imageData: Data?
    @State private var isLoading = false
    @State private var loadingFailed = false
    
    init(
        url: String?,
        placeholder: String,
        width: CGFloat,
        height: CGFloat,
        cornerRadius: CGFloat = 0
    ) {
        self.url = url
        self.placeholder = placeholder
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Group {
            if let imageData = imageData, !loadingFailed {
                
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    
                    Image(placeholder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            } else if isLoading {
              
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                        .scaleEffect(0.8)
                }
            } else {
               
                Image(placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .onAppear {
            loadImage()
        }
        .onChange(of: url) { _ in
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = url,
              !urlString.isEmpty,
              let imageUrl = URL(string: urlString) else {
            loadingFailed = true
            return
        }
        
     
        imageData = nil
        loadingFailed = false
        isLoading = true
        
        print("🖼️ Загружаем изображение: \(urlString)")
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: imageUrl)
                
                // Проверяем HTTP статус
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    
                    await MainActor.run {
                        self.imageData = data
                        self.isLoading = false
                        print("✅ Изображение загружено успешно: \(urlString)")
                    }
                } else {
                    await MainActor.run {
                        self.loadingFailed = true
                        self.isLoading = false
                        print("❌ Ошибка HTTP при загрузке изображения: \(urlString)")
                    }
                }
            } catch {
                await MainActor.run {
                    self.loadingFailed = true
                    self.isLoading = false
                    print("❌ Ошибка загрузки изображения: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AsyncImageView(
            url: "https://example.com/logo.png",
            placeholder: "RJDmock",
            width: 38,
            height: 38,
            cornerRadius: 12
        )
        
        AsyncImageView(
            url: nil,
            placeholder: "FGKmock",
            width: 38,
            height: 38,
            cornerRadius: 12
        )
    }
    .padding()
}
