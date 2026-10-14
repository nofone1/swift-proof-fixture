import SwiftUI
import UIKit

struct ContentView: View {
    private enum Screen {
        case home
        case details
    }

    @AppStorage("swift_minimal_note") private var note = "Edit this note, rebuild, then relaunch."
    @AppStorage("swift_minimal_keep_loop_visible") private var keepLoopVisible = true
    @State private var screen: Screen = .home
    @State private var attachedPhoto: UIImage?
    @State private var showsCamera = false
    @State private var showsNoCameraAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Xcode / SwiftUI")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundStyle(Color(red: 0.43, green: 0.35, blue: 0.22))

                Text(screen == .home ? "swift-minimal" : "Details")
                    .font(.system(size: 34, weight: .bold, design: .rounded))

                Text("Tiny rebuild-first sample for dogfooding onboarding, navigation, and relaunch persistence.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)

                infoCard {
                    detailRow(label: "Sample", value: "swift-minimal")
                    detailRow(label: "Build system", value: "Xcode")
                    detailRow(label: "Platform", value: "iOS Simulator")
                    detailRow(label: "Build marker", value: "swift-minimal@1.0")
                }

                if screen == .home {
                    infoCard {
                        Text("Home")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Edit the, flip the persisted toggle, then relaunch the simulator to confirm UserDefaults kept everything.")
                            .foregroundStyle(.secondary)

                        TextField("Persistent note", text: $note, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(4, reservesSpace: true)

                        Toggle("Keep rebuild loop visible", isOn: $keepLoopVisible)

                        Text("Relaunch-proof check: saved locally in UserDefaults.")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.17, green: 0.37, blue: 0.34))

                        Button("Open details") {
                            screen = .details
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    infoCard {
                        Text("Photo")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Attach a photo taken with the camera to this note.")
                            .foregroundStyle(.secondary)

                        if let attachedPhoto {
                            Image(uiImage: attachedPhoto)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                            Button("Remove photo", role: .destructive) {
                                self.attachedPhoto = nil
                            }
                            .buttonStyle(.bordered)
                        } else {
                            Button("Take photo") {
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    showsCamera = true
                                } else {
                                    showsNoCameraAlert = true
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else {
                    infoCard {
                        Text("Details")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Second screen in the shared dogfood contract.")
                            .foregroundStyle(.secondary)

                        detailRow(label: "Saved note", value: note)
                        detailRow(label: "Photo", value: attachedPhoto == nil ? "None attached" : "Attached from camera")
                        detailRow(label: "Saved toggle", value: keepLoopVisible ? "On across relaunches" : "Off across relaunches")
                        detailRow(label: "Journey", value: "Init -> dev -> edit -> rebuild -> relaunch -> confirm state")

                        Button("Back home") {
                            screen = .home
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding(24)
        }
        .background(Color(red: 0.96, green: 0.94, blue: 0.90))
        .fullScreenCover(isPresented: $showsCamera) {
            CameraPicker(image: $attachedPhoto, isPresented: $showsCamera)
                .ignoresSafeArea()
        }
        .alert("No camera available", isPresented: $showsNoCameraAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This device has no camera, so a photo can't be taken here.")
        }
    }

    @ViewBuilder
    private func infoCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(.primary)
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            parent.image = info[.originalImage] as? UIImage
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
