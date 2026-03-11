import SwiftUI
import AVKit

struct MyReusableView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Load image from CommonComponents/Images/
            CommonComponentsManager.shared.image(named: "birthdaybg_dark.png")
                .resizable()
                .scaledToFit()
                .frame(height: 100)

            // Load video from CommonComponents/Videos/
            if let url = CommonComponentsManager.shared.videoURL(named: "newvideo.mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 200)
                    .clipped()
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}