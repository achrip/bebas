import SwiftUI

struct OnBoardingListiew: View {
    @Binding var path: [Route]

    @State private var currentOnBoardingIndex: Int = 0
    
    var onClick: () -> Void

    let onboardingData: [(image: String, direction: String, description: String)] = [
        ("orientasi0", "Pastikan jaraknya aman", "Jarak yang aman kurang lebih 1 meter dengan syarat area pinggang ke atas dan bentangan tangan terlihat"),
        ("orientasi1", "Pastikan kontrasnya aman", "PMulai dari pencahayaan yang cukup hingga warna pakaian serta background yang kontras dengan warna kulit")
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    Capsule()
                        .frame(width: 40, height: 5)
                        .foregroundColor(currentOnBoardingIndex == index ? .black : .gray.opacity(0.4))
                }
            }
            .padding(.top)

            TabView(selection: $currentOnBoardingIndex) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnBoardingCameraView(
                        image: onboardingData[index].image,
                        direction: onboardingData[index].direction,
                        description: onboardingData[index].description
                    )
                    .tag(index)
                    .padding(.horizontal)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentOnBoardingIndex)
            
            Spacer()
            
            if currentOnBoardingIndex < 1 {
                Button(
                    action: {
                        currentOnBoardingIndex += 1
                    }, label: {
                        VStack {
                            Text("Berikutnya")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .frame(width: 250, height: 50)
                        .background(Color(hex: "#18C0A1"))
                        .cornerRadius(10)
                    }
                )
            } else {
                Button(
                    action: {
                        onClick()
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
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeLast()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Dashboard")
                    }
                }
            }
        }
    }
    
    func OnBoardingCameraView(image: String, direction: String, description: String) -> some View {
        VStack(spacing: 16) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 340, height: 340)
                .clipped()
                .cornerRadius(10)
            Text(direction)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            Text(description)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
}

#Preview {
}

