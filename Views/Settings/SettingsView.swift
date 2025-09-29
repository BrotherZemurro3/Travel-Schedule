

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsViewModel.self) private var settingsViewModel
    @Environment(TravelViewModel.self) private var travelViewModel
    @Environment(\.colorScheme) private var colorScheme


    var body: some View {
        @Bindable var settingsViewModel = settingsViewModel
        @Bindable var travelViewModel = travelViewModel
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Тёмная тема")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDay)
                    Spacer()
                    Toggle("", isOn: $settingsViewModel.isDarkMode)
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.whiteDay.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
             
                HStack{
                        Text("Пользовательское соглашение")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.blackDay)
                    
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                   
                    Spacer()
                    Button(action: {
                        travelViewModel.navigationPath.append(ContentView.Destination.settings(destination: .agreement))
                    }) { Image(systemName: "chevron.forward")
                            .foregroundStyle(.blackDay)
                    }
                    
                    .padding(.horizontal, -17)
                    .padding(.vertical, 8)
                    .frame(width: 34, height: 34)
                    
                }
                
                Button(action: {
                    travelViewModel.navigationPath.append(ContentView.Destination.settings(destination: .noInternet))
                }) {
                    Text("Показать экран 'Нет интернета'")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDay)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.whiteDay.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                }
                
                Button(action: {
                    travelViewModel.navigationPath.append(ContentView.Destination.settings(destination: .serverError))
                }) {
                    Text("Показать экран 'Ошибка сервера'")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDay)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.whiteDay.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                }

                Spacer()
                
                Spacer().frame(height: 20)
                
                VStack(alignment: .center, spacing: 16){
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.blackDay)
                        .lineLimit(1)
                       
                    Text("Версия 1.0 (beta)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.blackDay)
                        .lineLimit(1)
                }
                .frame(width: 343, height: 44)
                .padding(.horizontal, 30)
                }
            .toolbar(.visible, for: .tabBar)
            .preferredColorScheme(settingsViewModel.colorScheme)
            .onAppear {
                settingsViewModel.isDarkMode = settingsViewModel.selectedTheme == .dark ||
                    (settingsViewModel.selectedTheme == .auto && colorScheme == .dark)
            }
            .onChange(of: settingsViewModel.isDarkMode) { newValue in
                settingsViewModel.updateDarkMode(newValue)
            }
            .onChange(of: colorScheme) { newValue in
                settingsViewModel.updateToggleForSystemTheme(newValue)
            }
    }
}
#Preview {
    SettingsView()
}
