import SwiftUI

struct DashboardView: View {
    @State var path = NavigationPath()
    @State private var currentIndex = 0

    // MARK: -- Private Things
    private let images = [
        "beranda_iklan1", "beranda_iklan2", "beranda_iklan3", "beranda_iklan4",
    ]
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack(path: $path) {
            // MARK: -- Header
            HStack {
                Text("Selamat datang di")
                    .font(.title)
                Text("BEBAS")
                    .font(.title)
                    .bold()
                Spacer()
            }

            Carousel()

            Text("Apa yang ingin kamu pelajari hari ini?")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(.systemGray))
                .font(.subheadline)

            Spacer()

            VStack {
                HStack {
                    Text("Aktivitas di Bebas")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }

                HStack {
                    DashboardButton(title: "Belajar", image: "beranda_belajar", color: .green){
                        path.append("WordSelection")
                    }
                    DashboardButton(title: "Praktik", image: "beranda_praktik", color: .blue){
                        path.append("GesturePractice")
                    }
                }

                HStack {
                    DashboardButton(title: "Kamus", image: "beranda_kamus", color: .orange){
                        path.append("GestureDictionary")
                    }
                    DashboardButton(title: "Eja Kata", image: "beranda_ejakata", color: .red){
                        path.append("SentenceSpelling")
                    }
                }
            }
        }
        .padding()
        .navigationDestination(for: String.self) { value in
            switch value {
            case "WordSelection":
                WordSelectionView(path: $path)
//            case "GesturePractice":
//                GesturePracticeView()
//            case "GestureDictionary":
//                GestureDictionaryView()
//            case "SentenceSpelling":
//                SentenceSpellingView()
            default:
                Text("⚠︎ ERROR ⚠︎")
            }
        }
    }
}

extension DashboardView {

    @ViewBuilder
    private func Carousel() -> some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                DashboardImage(image: images[index])
                    .tag(index)
            }
        }
        .frame(height: 180)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .cornerRadius(10)
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }

    @ViewBuilder
    private func DashboardImage(image: String) -> some View {
        HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        }
    }

    @ViewBuilder
    private func DashboardButton(title: String, image: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 130)
                Spacer()
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 2)
            )
        }
    }
}

#Preview {
    DashboardView()
}
