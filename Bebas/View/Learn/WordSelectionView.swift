import SwiftUI

struct WordSelectionView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dismiss) private var dismiss

    @Binding var path: NavigationPath

    @State private var searchText: String = ""
    @State var data: [String] = []

    var body: some View {
        ScrollView {
            VStack {
                ForEach(WordData.options) { word in
                    WordOptionView(
                        word: word.word, description: word.description, image: word.image
                    ) { path.append("onboarding") }
                }
            }
            .padding(.horizontal)
        }
        .searchable(
            text: $searchText,
            placement: sizeClass == .regular
                ? .toolbar
                : .navigationBarDrawer(displayMode: .always),
            prompt: "Search local note board"
        )
        .navigationTitle("Belajar")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { path.removeLast() }) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        }
    }
}

extension WordSelectionView {

    @ViewBuilder
    private func WordOptionView(
        word: String, description: String, image: String, action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primary, lineWidth: 1)
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
                    .foregroundColor(Color.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray),
                alignment: .bottom
            )
        }
    }
}

#Preview {
    let path = NavigationPath()
    WordSelectionView(path: .constant(path))
}
