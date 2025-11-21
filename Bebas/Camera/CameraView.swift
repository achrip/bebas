import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var handPoints: [CGPoint]
    @Binding var predictedString: String
    @Binding var predictedPercentage: [String : Double]

    func makeUIViewController(context: Context) -> some UIViewController {

        let cameraViewController = CameraViewController()
        
        cameraViewController.onHandPointsDetected = { points in
            handPoints = points
        }

        cameraViewController.onPredictGesture = { prediction in
            predictedString = prediction
        }
        
        cameraViewController.onPredictPercentage = { percentage in
            predictedPercentage = percentage
        }
        
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
