

import Foundation
import SwiftUI
import Observation

@Observable
class SettingsViewModel {
    
    
    // MARK: - Properties
    var selectedTheme: Theme = .auto
    var isDarkMode: Bool = false
    
    var navigationPath = NavigationPath()
    private let themeKey = "selectedTheme"
    
    init() {
        loadTheme()
    }
    
    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .auto:
            return nil // Системная тема
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    // MARK: - Public Methods

    func loadTheme() {
        if let savedTheme = UserDefaults.standard.string(forKey: themeKey),
           let theme = Theme(rawValue: savedTheme) {
            selectedTheme = theme
        }
    }
    
    func saveTheme() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
    }
    
    func updateTheme(_ newTheme: Theme) {
        selectedTheme = newTheme
        saveTheme()
    }
    
    func updateDarkMode(_ isDark: Bool) {
        isDarkMode = isDark
        selectedTheme = isDark ? .dark : .light
        saveTheme()
    }
    func updateToggleForSystemTheme(_ systemColorScheme: ColorScheme) {
        if selectedTheme == .auto {
            isDarkMode = systemColorScheme == .dark
        }
    }

    
}

// MARK: - Navigation Destinations

/// Направления навигации в настройках
enum SettingsDestination: Hashable {
    case noInternet
    case serverError
    case agreement
}
