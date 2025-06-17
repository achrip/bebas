import SwiftUI

// MARK: - RootView
struct RootView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Root View")
                    .font(.largeTitle)
                Button("Go to List View") {
                    path.append("List")
                }
                .padding()
            }
            .navigationDestination(for: String.self) { value in
                if value == "List" {
                    ListView(path: $path)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - ListView
struct ListView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack {
            Text("List View")
                .font(.largeTitle)
            Button("Go to Onboard View") {
                path.append("Onboard")
            }
            .padding()
        }
    }
}

// MARK: - OnboardView
struct OnboardView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack {
            Text("Onboard View")
                .font(.largeTitle)
            Button("Go to Camera View") {
                path.append("Camera")
            }
            .padding()
        }
    }
}

// MARK: - CameraView
struct CamView: View {
    @Binding var path: NavigationPath
        @State private var showOverlay = false

        var body: some View {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                VStack {
                    Text("Camera View")
                        .font(.largeTitle)
                    Button("Show Overlay") {
                        showOverlay = true
                    }
                    .padding()
                }

                if showOverlay {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    VStack {
                        Text("Overlay View")
                            .font(.title)
                            .foregroundColor(.white)
                        Button("Back to List View (from overlay)") {
                            jumpBackToList()
                            showOverlay = false
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true) // hide native back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back to List") {
                        jumpBackToList()
                    }
                }
            }
        }

        private func jumpBackToList() {
            // Remove views until only one (the ListView) remains
            let newCount = max(path.count - (path.count - 1), 0)
            path.removeLast(path.count - newCount)
        }
}

#Preview {
    RootView()
}
