//
//  LearnChooseWordView.swift.swift
//  Bebas
//
//  Created by Adya Muhammad Prawira on 13/06/25.
//

import SwiftUI

struct LearnListWordsView: View {
    @EnvironmentObject var globalData: GlobalData
    @Environment(\.horizontalSizeClass) private var sizeClass

    @Binding var path: [Route]

    @State private var searchText: String = ""
    @State var data: [String] = []
    @State private var isSheet: Bool = false
    
    var filteredWords: [WordOption] {
        if searchText.isEmpty {
            return WordData.options
        } else {
            return WordData.options.filter {
                $0.word.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
        
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(filteredWords) { word in
                    WordOptionView(word: word.word, description: word.description, image: word.image)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .searchable(
            text: $searchText,
            placement: sizeClass == .regular
            ? .toolbar
            : .navigationBarDrawer(displayMode: .always),
            prompt: "Search local note board"
        )
        .navigationTitle("Belajar")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeAll()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Dashboard")
                    }
                }
            }
        }
    }
    
    func WordOptionView(word: String, description: String, image: String) -> some View {
        Button(action: {
            globalData.word = word
            globalData.image = image
            path.append(.learnCamera)
        }, label: {
            HStack(spacing: 16) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                VStack(alignment: .leading) {
                    Text(word)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray),
                alignment: .bottom
            )
        })
    }
}
