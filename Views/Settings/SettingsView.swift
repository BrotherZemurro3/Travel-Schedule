//
//  SettingsView.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 22.07.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("theme") private var selectedTheme: Theme = .auto
    @Environment(\.colorScheme) private var colorScheme
    @State private var isDarkMode: Bool = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Тёмная тема")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDay)
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.whiteDay.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                
                
                Button(action: {
                    navigationPath.append(SettingsDestination.noInternet)
                }) {
                    Text("Показать экран 'Нет интернета'")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDay)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.whiteDay.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                }
                
                Button(action: {
                    navigationPath.append(SettingsDestination.serverError)
                }) {
                    Text("Показать экран 'Ошибка сервера'")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDay)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.whiteDay.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                }
                
                
                Spacer()
            }
            .toolbar(.visible, for: .tabBar)
            .preferredColorScheme(selectedTheme == .auto ? nil : (selectedTheme == .dark ? .dark : .light))
            .onAppear {
                // Устанавливаю начальное состояние Toggle
                isDarkMode = selectedTheme == .dark || (selectedTheme == .auto && colorScheme == .dark)
            }
            .onChange(of: isDarkMode) { newValue in
                // Обновляю selectedTheme при изменении Toggle
                selectedTheme = newValue ? .dark : .light
            }
            .onChange(of: colorScheme) { newValue in
                // Обновляю isDarkMode при изменении системной темы, если selectedTheme == .auto
                if selectedTheme == .auto {
                    isDarkMode = newValue == .dark
                }
            }
            .navigationDestination(for: SettingsDestination.self) { destination in
                Group {
                    switch destination {
                    case .noInternet:
                        NoInternetView(navigationPath: $navigationPath)
                    case .serverError:
                        ServerErrorView(navigationPath: $navigationPath)
                    }
                }
            }
        }
    }
enum SettingsDestination: Hashable {
     case noInternet
     case serverError
 }
}
#Preview {
    SettingsView()
}
