//
//  SpellWordView.swift
//  Bebas
//
//  Created by Adya Muhammad Prawira on 18/06/25.
//

import SwiftUI

struct SpellWordView: View {
    @Binding var path: [Route]

    @State private var currentWord: String = ""
    @State private var userAnswer: [OptionItem] = []
    @State private var options: [OptionItem] = []
    @State private var toggledChars: Set<UUID> = []
    @State private var isCorrect: Bool = false
    @State private var isShow: Bool = false

    let randomWord: [String] = [
        "17 Agustus", "59 Apel", "Tinggi 123", "4 Gajah", "Kota 21",
        "Sapi 007", "Rumah 88", "Meja 2", "Pohon 1", "Laptop 3",
        "Ulang 09", "Buku 101", "7 Topi", "Air 33", "Mobil 4",
        "8 Jalan", "Kursi 5", "3 Ekor", "Tangan 9", "Jendela7",
        "Kopi 89", "Bola 10", "Sikat 33", "99 Bintang", "Laut 45",
        "5 Motor", "Jam 123", "Kunci 0", "Telepon 11", "9 Piring",
        "Bendera 8", "Sapu 66", "Tas 101", "Kertas 34", "Pensil 56",
        "Buku Merah", "1 Komputer", "Gelas Biru", "Mobil Putih", "99 Cermin"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text(currentWord)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)

            Spacer()

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 8) {
                ForEach(options) { item in
                    Button {
                        toggleChar(item)
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image("alfanumerik_\(item.value.lowercased())")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .background(
                                    toggledChars.contains(item.id)
                                    ? Color(hex: "#18C0A1")
                                    : Color(hex: "#BBF2E8")
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "#18C0A1"), lineWidth: 2)
                                )
                                .cornerRadius(10)

                            if let index = indexOfChar(item) {
                                Text("\(index + 1)")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .padding(6)
                            }
                        }
                    }
                }
            }

            Spacer()

            Button {
                if !userAnswer.isEmpty {
                    let cleanedTarget = currentWord.replacingOccurrences(of: " ", with: "").lowercased()
                    let userInput = userAnswer.map { $0.value }.joined().lowercased()
                    isCorrect = userInput == cleanedTarget
                    isShow = true
                }
            } label: {
                Text("Cek")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(userAnswer.isEmpty ? Color(hex: "#B6B6B5") : Color(hex: "#18C0A1"))
                    .cornerRadius(10)
            }

            Spacer()
            Spacer()
        }
        .padding()
        .onAppear(perform: generateNewWord)
        .overlay {
            if isShow {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 16) {
                    Image("belajar_selesai")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipped()

                    Text(isCorrect ? "Jawaban benar" : "Jawaban salah")
                        .font(.title2)
                        .bold()

                    Text(isCorrect
                          ? "Selamat! Kamu berhasil menjawab soal eja kata, mari kita eja lagi!"
                          : "Yah kurang tepat! Yuk, coba lagi dan perhatikan bahasa isyaratnya satu per satu!")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 20) {
                        if isCorrect {
                            Button("Kembali") {
                                path.removeLast()
                            }
                            .frame(width: 120, height: 44)
                            .background(Color(hex: "#DEF9F4"))
                            .foregroundColor(Color(hex: "#18C0A1"))
                            .cornerRadius(10)

                            Button("Lanjut") {
                                generateNewWord()
                                isShow = false
                            }
                            .frame(width: 120, height: 44)
                            .background(Color(hex: "#18C0A1"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        } else {
                            Button("Ulangi") {
                                isShow = false
                            }
                            .frame(width: 200, height: 44)
                            .background(Color(hex: "#18C0A1"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
        .navigationTitle("Eja Kata")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    path.removeAll()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Dashboard")
                    }
                }
            }
        }
    }

    func generateNewWord() {
        currentWord = randomWord.randomElement()!
        let chars = Array(currentWord.replacingOccurrences(of: " ", with: "").lowercased()).map { String($0) }

        let allChars = Array("abcdefghijklmnopqrstuvwxyz0123456789").map { String($0) }
        var other: [String] = []
        while (chars.count + other.count) < 9 {
            let rand = allChars.randomElement()!
            if !chars.contains(rand) && !other.contains(rand) {
                other.append(rand)
            }
        }

        options = (chars + other).map { OptionItem(value: $0) }.shuffled()
        userAnswer = []
        toggledChars = []
    }

    func toggleChar(_ item: OptionItem) {
        if toggledChars.contains(item.id) {
            toggledChars.remove(item.id)
            if let index = userAnswer.firstIndex(where: { $0.id == item.id }) {
                userAnswer.remove(at: index)
            }
        } else {
            toggledChars.insert(item.id)
            userAnswer.append(item)
        }
    }

    func indexOfChar(_ item: OptionItem) -> Int? {
        guard toggledChars.contains(item.id) else { return nil }
        return userAnswer.firstIndex(where: { $0.id == item.id })
    }
}
