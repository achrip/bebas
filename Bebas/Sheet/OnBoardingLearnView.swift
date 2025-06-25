import SwiftUI

struct OnBoardingLearnView: View {
    @EnvironmentObject var globalData: GlobalData
    @Environment(\.dismiss) var dismiss

    @State private var currentOnBoardingIndex: Int = 0

    let onboardingData: [(image: String, direction: String, description: String)] = [
        ("orientasi0", "Posisi Ideal (Duduk & Berdiri):", "Atur jarak ±1m (pastikan pinggang ke atas dan bentangan tangan terlihat jelas)."),
        ("orientasi1", "Pencahayaan & Kontras Optimal:", "Optimalkan cahaya, pakaian dan background (kontras).")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {                
                Text("Video Praktik \"\(globalData.word)\"")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.title2)
                
                
                VStack {
                    if let videoURL = Bundle.main.url(forResource: "belajar_\(globalData.word.lowercased())", withExtension: "MOV") {
                        LoopingVideoPlayer(videoURL: videoURL)
                            .frame(height: 200)
                            .overlay(
                                Color.black.opacity(0.25)
                            )
                    } else {
                        Text("Video tidak ditemukan.")
                    }
                }
                .padding()
                .cornerRadius(10)
                
                
                Text("Pastikan ikuti panduan berikut untuk hasil yang maksimal:")
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                    .bold()
                    .frame(maxWidth: .infinity)
                
                
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnBoardingCameraView(
                        image: onboardingData[index].image,
                        direction: onboardingData[index].direction,
                        description: onboardingData[index].description
                    )
                    .tag(index)
                    .padding(.horizontal)
                }
                
                Spacer()

                Button(
                    action: {
                        dismiss()
                    }, label: {
                        VStack {
                            Text("Mulai")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .frame(width: 250, height: 50)
                        .background(Color(hex: "#18C0A1"))
                        .cornerRadius(10)
                    }
                )
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func OnBoardingCameraView(image: String, direction: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipped()
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(direction)
                    .bold()
                Text(description)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
}

#Preview {
//    OnBoardingLearnView()
}

