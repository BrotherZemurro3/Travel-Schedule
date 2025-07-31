//
//  SearchBar.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 28.07.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.grayUniversal)
                .padding(.leading, 8)
            TextField("Введите запрос", text: $searchText)
                .padding(8)
                .padding(.trailing, 8)
                .foregroundColor(.blackDay)
                .overlay(
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.grayUniversal)
                            }
                            .padding(.trailing, 16)
                        }
                    }
                )
        }
        .background(colorScheme == .dark ? .fillsTertiaryDark : .lightGray)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

#Preview {
    struct SearchBarPreview: View {
        @State private var searchText = ""
        var body: some View {
            SearchBar(searchText: $searchText)
        }
    }
    return SearchBarPreview()
}
