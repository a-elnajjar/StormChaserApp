//
//  CameraView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct CameraView: View {
    @State private var cameraVM = CameraViewModel()
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if cameraVM.showMetadataForm, let photo = cameraVM.selectedImage {
                    MetadataFormView(
                        stormType: $cameraVM.stormType,
                        notes: $cameraVM.notes,
                        intensity: $cameraVM.intensity,
                        duration: $cameraVM.duration,
                        temperature: cameraVM.weatherData?.temperature,
                        humidity: cameraVM.weatherData?.humidity,
                        windSpeed: cameraVM.weatherData?.windSpeed,
                        weatherDescription: cameraVM.weatherData?.description,
                        latitude: cameraVM.currentLocation?.lat ?? 0,
                        longitude: cameraVM.currentLocation?.lon ?? 0,
                        onSave: { cameraVM.saveStorm(photo: photo, modelContext: modelContext) }
                    )
                } else {
                    Group {
                        if let image = cameraVM.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .cornerRadius(12)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                                Text("No Photo Selected")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, minHeight: 300)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }

                    Button(action: { cameraVM.showCamera = true }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Take Photo")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()

                    if cameraVM.selectedImage != nil {
                        Button(action: {
                            Task { await cameraVM.prepareMetadataForm(userLocation: appState.userLocation, debugCity: appState.debugCity) }
                        }) {
                            HStack {
                                if cameraVM.isPreparingMetadata {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                }
                                Text("Continue")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .disabled(cameraVM.isPreparingMetadata)
                    }
                }
            }
            .padding()
            .navigationTitle("Document Storm")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $cameraVM.showCamera) {
            CameraCapture(image: $cameraVM.selectedImage, isPresented: $cameraVM.showCamera)
        }
        .alert("Storm Saved", isPresented: $cameraVM.showSuccessAlert) {
            Button("OK") { cameraVM.showSuccessAlert = false }
        } message: {
            Text(cameraVM.alertMessage)
        }
    }
}

// MARK: - CameraCapture

struct CameraCapture: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, isPresented: $isPresented)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: UIImage?
        @Binding var isPresented: Bool

        init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
            _image = image
            _isPresented = isPresented
        }

        func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            image = info[.originalImage] as? UIImage
            isPresented = false
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            isPresented = false
        }
    }
}

#Preview {
    CameraView()
        .environment(AppState())
}
