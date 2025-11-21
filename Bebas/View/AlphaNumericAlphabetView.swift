import SwiftUI

struct AlphaNumericAlphabetView: View {
    @Binding var path: [Route]

    @State private var cards: [Card] = AlphaNumericAlphabetView.generateCards()
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var searchLetter: String = ""

    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("Kartu \(currentIndex + 1)/\(cards.count)")
                    .foregroundColor(.black)
                    .bold()
            }
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
            
            ZStack {
                ForEach(Array(cards.enumerated()), id: \.1.id) { index, _ in
                    if abs(index - currentIndex) <= 2 {
                        CardView(card: $cards[index])
                            .offset(offsetForCard(at: index))
                            .rotationEffect(.degrees(rotationForCard(at: index)))
                            .scaleEffect(scaleForCard(at: index))
                            .opacity(opacityForCard(at: index))
                            .zIndex(Double(100 - abs(index - currentIndex)))
                    }
                }
            }
            .frame(height: 420)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation
                    }
                    .onEnded { _ in
                        let threshold: CGFloat = 100
                        if dragOffset.width < -threshold {
                            showNext()
                        } else if dragOffset.width > threshold {
                            showPrevious()
                        } else {
                            withAnimation {
                                dragOffset = .zero
                            }
                        }
                    }
            )
            .animation(.spring(), value: dragOffset)

            Text("Tekan untuk putar kartu!")
                .foregroundColor(.gray)
                .bold()
            
            Spacer()
            Spacer()
        }
        .padding()
        .navigationTitle("Kamus")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeLast()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Alfanumerik")
                    }
                }
            }
        }
    }

    func showNext() {
        if currentIndex < cards.count - 1 {
            withAnimation(.spring()) {
                currentIndex += 1
                dragOffset = .zero
            }
        } else {
            withAnimation {
                dragOffset = .zero
            }
        }
    }

    func showPrevious() {
        if currentIndex > 0 {
            withAnimation(.spring()) {
                currentIndex -= 1
                dragOffset = .zero
            }
        } else {
            withAnimation {
                dragOffset = .zero
            }
        }
    }

    func offsetForCard(at index: Int) -> CGSize {
        if index == currentIndex {
            return dragOffset
        } else {
            let dx = CGFloat(index - currentIndex) * 20
            return CGSize(width: dx, height: CGFloat(abs(index - currentIndex)) * 10)
        }
    }

    func rotationForCard(at index: Int) -> Double {
        if index == currentIndex {
            return Double(dragOffset.width / 20)
        } else {
            return cards[index].rotation
        }
    }

    func scaleForCard(at index: Int) -> CGFloat {
        index == currentIndex ? 1.0 : 0.95
    }

    func opacityForCard(at index: Int) -> Double {
        abs(index - currentIndex) > 2 ? 0 : 1
    }

    static func generateCards() -> [Card] {
        let symbols = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return symbols.enumerated().map { (i, c) in
            Card(
                value: String(c),
                color: Color(hue: Double(i) / 26.0, saturation: 0.8, brightness: 0.9),
                rotation: Double.random(in: -8...8),
                image: "alfanumerik_\(c.lowercased())"
            )
        }
    }
}

#Preview {
//    CardAlphabetView()
}
