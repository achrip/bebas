import SwiftUI
import AVKit



struct LearnCameraView: View {
    @EnvironmentObject var globalData: GlobalData

    @Binding var path: [Route]

    @State private var handPoints: [CGPoint] = []
    @State private var predictedString: String = "Tidak Ada Kata"
    @State private var predictedPercentage: [String : Double] = ["Tidak Ada Kata" : 0.0]
    @State private var isCorrect: Bool = false
    @State private var isSheet: Bool = true
    @State private var progress: CGFloat = 0.0
    @State private var cameraViewHeight: CGFloat = 0.0

    private let interval: TimeInterval = 0.1
    private let maxDuration: TimeInterval = 2
    private var maxCount: Int { Int(maxDuration / interval) }
    private let bottomHeight: CGFloat = 345.0

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ZStack {
                CameraView(
                    handPoints: $handPoints,
                    predictedString: $predictedString,
                    predictedPercentage: $predictedPercentage
                )
                .edgesIgnoringSafeArea(.all)

//                pointsView
                LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.9), Color.clear]),
                        startPoint: .top,
                        endPoint: .center
                    )
                    .ignoresSafeArea()
            }
//            .offset(y: 76 - bottomHeight)
            
            VStack {
                Spacer()
                    .frame(height: 55.5)
                HStack {
                    Text({
                        let percentage = (predictedPercentage[predictedString] ?? 0.0) * 100
                        if !isCorrect && !isSheet && predictedString.lowercased() == globalData.word.lowercased() && percentage > 50 {
                            return "Nah bagus, pertahankan!"
                        } else if isCorrect && !isSheet {
                            return "Bagus, yuk belajar lagi!"
                        } else {
                            return "Masih belum benar!"
                        }
                    }())
                    .foregroundColor(.white)
                }
                .frame(height: 40)
                .padding(.horizontal, 8)
                .background({
                    let percentage = (predictedPercentage[predictedString] ?? 0.0) * 100
                    if !isCorrect && !isSheet && predictedString.lowercased() == globalData.word.lowercased() && percentage > 50 {
                        return Color.black.opacity(0.5)
                    } else if isCorrect && !isSheet {
                        return Color.green.opacity(0.5)
                    } else {
                        return Color.black.opacity(0.5)
                    }
                }())
                .cornerRadius(10)
                Spacer()
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        let fullWidth = geometry.size.width
                        let filledWidth = fullWidth * progress

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.black)
                                .opacity(0.5)
                                .frame(height: 44)

                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.green)
                                .frame(width: filledWidth, height: 44)

                            HStack {
                                Spacer()
                                Text(globalData.word.capitalized)
                                    .foregroundColor(.white)
                                    .bold()
                                Spacer()
                            }
                            .frame(height: 44)
                        }
                    }
                }
                .frame(height: 44)
                .padding([.horizontal, .bottom], 40)
                
//                VStack {
//                    HStack {
//                        Text("Yang diperagakan: ")
//                            .bold()
//                        let percentage = (predictedPercentage[predictedString] ?? 0.0) * 100
//                        Text(
//                            predictedString == "Tidak Ada Kata" ?
//                                predictedString
//                            :
//                                "\(predictedString) (\(String(format: "%.1f", percentage))%)"
//                        )
//                        .bold()
//                    }
//                    .padding(8)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                }
//                .padding(.vertical, 8)
                
//                VStack {
//                    if let videoURL = Bundle.main.url(forResource: "belajar_\(globalData.word.lowercased())", withExtension: "MOV") {
//                        VStack(spacing: 0) {
//                            LoopingVideoPlayer(videoURL: videoURL)
//                                .overlay(
//                                    Color.black.opacity(0.5)
//                                )
//                            Text("Peragakan gerakan sampai bar penuh")
//                                .multilineTextAlignment(.center)
//                                .padding(.vertical, 8)
//                                .foregroundColor(.white)
//                                .bold()
//                                .frame(maxWidth: .infinity)
//                                .background(Color(hex: "#18C0A1"))
//                        }
//                        .cornerRadius(10)
//                    } else {
//                        Text("Video tidak ditemukan.")
//                    }
//                    Spacer()
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .frame(height: bottomHeight)
//                .background(Color.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .sheet(isPresented: $isSheet) {
            OnBoardingLearnView()
                .environmentObject(globalData)
                .presentationDetents([.fraction(0.95)])
                .presentationDragIndicator(.visible)
        }
        .onReceive(timer) { _ in
            let zeroPoints = handPoints.filter { $0 == .zero }.count
            if !handPoints.isEmpty && CGFloat(zeroPoints) / CGFloat(handPoints.count) > 0.6 {
                predictedString = "Tidak Ada Kata"
            }

            let percentage = (predictedPercentage[predictedString] ?? 0.0) * 100
            if !isCorrect && !isSheet && predictedString.lowercased() == globalData.word.lowercased() && percentage > 50 {
                progress += 1 / CGFloat(maxCount)
            }
            if progress >= 1 {
                isCorrect = true
                progress = 0
            }
        }
        .overlay {
            if isCorrect {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 16) {
                    Image("belajar_selesai")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipped()

                    Text("Misi Selesai")
                        .font(.title2)
                        .bold()

                    Text("Selamat! Kamu berhasil belajar memperagakan satu bahasa isyarat!")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 20) {
                        Button("Ulangi") {
                            isCorrect = false
                            progress = 0
                            // Optionally clear other states if needed
                        }
                        .frame(width: 120, height: 44)
                        .background(Color(hex: "#DEF9F4"))
                        .foregroundColor(Color(hex: "#18C0A1"))
                        .cornerRadius(10)
                        
//                        NavigationLink{
//                            
//                        }
                        Button("Lanjut") {
                            path.removeLast(1)
//                            path.append(.practiceCamera)
                        }
                        .frame(width: 120, height: 44)
                        .background(Color(hex: "#18C0A1"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeLast()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.white)
                        Text("List")
                            .foregroundColor(Color.white)
                            .bold()
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

#Preview {
    LearnCameraView(path: .constant([]))
        .environmentObject(GlobalData())
}
