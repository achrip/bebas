//
//  DashboardView.swift
//  Bebas
//
//  Created by Adya Muhammad Prawira on 09/06/25.
//

import SwiftUI
import AVKit
import WebKit

struct DashboardView: View {
    @AppStorage("pertamaKaliBukaAplikasiBebas") var firstTimeOpenBebasApp: Bool = false

    @StateObject var globalData = GlobalData()

    @State private var currentIndex: Int = 0
    @State private var path: [Route] = []

    private var images: [String] = ["beranda_iklan1", "beranda_iklan2", "beranda_iklan3", "beranda_iklan4"]
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Text("Selamat datang di")
                        .font(.title2)
                    Text("BEBAS")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                Text("Apa yang ingin kamu pelajari hari ini?")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.systemGray))
                    .font(.subheadline)
                
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
                
                Spacer()
                    .frame(height: 24)
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Aktivitas di Bebas")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            path.append(.onBoardingList)
                        }, label: {
                            DashboardButton(title: "Belajar", image: "beranda_belajar", color: .green)
                        })
                        Button(action: {
                            path.append(.practiceCamera)
                        }, label: {
                            DashboardButton(title: "Praktik", image: "beranda_praktik", color: .blue)
                        })
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            path.append(.alphaNumericAlphaNumeric)
                        }, label: {
                            DashboardButton(title: "Alfanumerik", image: "beranda_alfanumerik", color: .orange)
                        })
                        Button(action: {
                            path.append(.spellWord)
                        }, label: {
                            DashboardButton(title: "Eja Kata", image: "beranda_ejakata", color: .red)
                        })
                    }
                }
            }
            .padding(24)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .onBoardingList:
                    if !firstTimeOpenBebasApp {
                        OnBoardingListiew(path: $path, onClick: {
                            firstTimeOpenBebasApp = true
                            path.append(.onBoardingList)
                        })
                    } else {
                        LearnListWordsView(path: $path)
                            .environmentObject(globalData)
                    }
//                case .learnListWords:
//                    LearnListWordsView(path: $path)
//                        .environmentObject(globalData)
                case .learnCamera:
                    LearnCameraView(path: $path)
                        .environmentObject(globalData)
                case .practiceCamera:
                    PracticeCameraView(path: $path)
                case .alphaNumericAlphaNumeric:
                    AlphaNumericOptionView(path: $path)
                case .alphaNumericAlphabet:
                    AlphaNumericAlphabetView(path: $path)
                case .alphaNumericNumber:
                    AlphaNumericNumberView(path: $path)
                case .spellWord:
                    SpellWordView(path: $path)
                }
            }
//            .onAppear {
////                if firstTimeOpenBebasApp && path.isEmpty {
////                    path.append(.learnListWords)
////                }
//            }
        }
    }
    
    func DashboardImage(image: String) -> some View {
        HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        }
    }
    
    func DashboardButton(title: String, image: String, color: Color) -> some View {
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

#Preview {
    DashboardView()
}
