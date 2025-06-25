//
//  PracticeCameraView.swift
//  Bebas
//
//  Created by Adya Muhammad Prawira on 16/06/25.
//
import SwiftUI

struct PracticeCameraView: View {
    @EnvironmentObject var globalData: GlobalData
    
    @Binding var path: [Route]

    @State private var handPoints: [CGPoint] = []
    @State private var predictedString: String = "Tidak Ada Kata"
    @State private var predictedPercentage: [String : Double] = ["Tidak Ada Kata" : 0.0]
    @State private var wordBuffer: [String] = []
    @State private var bufferCount = 0
    @State private var progress: CGFloat = 0.0
    @State private var text: String = ""
    @State private var emptyText: String = "Peragakan kalimat disini!"
    @State private var isSheet: Bool = false

    private let interval: TimeInterval = 0.1
    private let bufferDuration: TimeInterval = 2.0
    private var maxBufferCount: Int { Int(bufferDuration / interval) }
    private let bottomHeight: CGFloat = 200
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ZStack {
                CameraView(handPoints: $handPoints, predictedString: $predictedString, predictedPercentage: $predictedPercentage)
//                Rectangle()
//                    .foregroundStyle(Color.red)
                pointsView
            }
//            .offset(y: 76 - bottomHeight)
            
            VStack {

                Spacer()
                
//                VStack {
//                    ProgressView(value: progress)
//                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
//                        .frame(height: 6)
//                        .background(Color.white)
//                        .cornerRadius(3)
//                        .padding(.horizontal)
//                }
//                VStack {
//                    HStack {
//                        Text("Yang diperagakan: ")
//                            .bold()
//                        let percentage = (predictedPercentage[predictedString] ?? 0.0) * 100
//                        Text(predictedString)
//                        .bold()
//                    }
//                    .padding(8)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                }
                .padding(.vertical, 8)
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        let fullWidth = geometry.size.width
                        let filledWidth = fullWidth * progress

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.black.opacity(0.5))
                                .frame(height: 64)

                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.green)
                                .frame(width: filledWidth, height: 64)

                            HStack {
                                Text(text.isEmpty ? emptyText : text.capitalized)
                                    .foregroundColor(text.isEmpty ? .white : .white)
                                    .bold()
                                    .padding(.horizontal)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    
                            }
                            .frame(height: 64)
                        }
                    }
                }
                .frame(height: 64)
                .padding([.horizontal, .bottom], 40)            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        var words = text.split(separator: " ").map { String($0) }
                        if !words.isEmpty {
                            words.removeLast()
                            text = words.joined(separator: " ")
                        }
                    }) {
                        Image(systemName: "eraser")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "#18C0A1"))
                            .cornerRadius(10)
                    }
                }
                .padding(30)
                Spacer()
                    .frame(height: 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.9), Color.clear]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
//            LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
//                    startPoint: .bottom,
//                    endPoint: .center
//                )
//                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .sheet(isPresented: $isSheet) {
            OnBoardingPracticeView(onClick: {
                isSheet = false
            })
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
        }
        .onReceive(timer) { _ in
            if !handPoints.allSatisfy({ $0 == .zero }) {
                let percentage = (predictedPercentage[predictedString] ?? 0.0) * 100
                
                wordBuffer.append(predictedString)
                bufferCount += 1
                progress = CGFloat(bufferCount) / CGFloat(maxBufferCount)
                
                if bufferCount >= maxBufferCount {
                    let counts = wordBuffer.reduce(into: [:]) { counts, word in
                        counts[word, default: 0] += 1
                    }
                    var word = counts.max(by: { $0.value < $1.value })?.key ?? ""
                    if word == "Tidak Ada Kata" {
                        word = ""
                    }
                    let words = text.split(separator: " ").map { String($0) }
                    if let lastWord = words.last, word == lastWord {
                        word = ""
                    }
                    if !word.isEmpty {
                        text += (text.isEmpty ? "" : " ") + word
                    }
                    bufferCount = 0
                    wordBuffer = []
                    progress = 0
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeAll()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.white)
                        Text("Dashboard")
                            .foregroundColor(Color.white)
                    }
                    .frame(height: 40)
                    .padding(.horizontal, 8)
//                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSheet = true
                }) {
                    VStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.white)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(100)
                }
            }
        }
    }

    private var pointsView: some View {
        ForEach(handPoints.indices, id: \.self) { index in
            let point = handPoints[index]
            Circle()
                .fill(.orange)
                .frame(width: 8)
                .position(x: point.x, y: point.y)
        }
    }
}

//#Preview {
//    PracticeCameraView(globalData: <#T##GlobalData#>, path: <#T##[Route]#>, handPoints: <#T##[CGPoint]#>, predictedString: <#T##String#>, predictedPercentage: <#T##[String : Double]#>, wordBuffer: <#T##[String]#>, bufferCount: <#T##arg#>, progress: <#T##CGFloat#>, text: <#T##String#>, emptyText: <#T##String#>, isSheet: <#T##Bool#>)
//}

#Preview {
    PracticeCameraView(path: .constant([]))
        .environmentObject(GlobalData())
}
