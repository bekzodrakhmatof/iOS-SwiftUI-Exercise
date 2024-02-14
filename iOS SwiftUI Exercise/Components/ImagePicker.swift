//
//  ImagePicker.swift
//  Legitmark
//
//  Created by Jiang Long on 11/30/23.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
  
  enum Mode {
    case takePhoto
    case openPhotos
  }

  let mode: Mode
  @Binding var selectedImage: UIImage?
  let cancelHandler: () -> Void

  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var parent: ImagePicker

    init(parent: ImagePicker) {
      self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        print("PICKED IMAGE IS NOT COMING: \(info)")
      let image: UIImage
      if let editedImage = info[.editedImage] as? UIImage {
        image = editedImage
      } else if let orginalImage = info[.originalImage] as? UIImage {
        image = orginalImage
      } else {
        fatalError()
      }

      // Crop center square
      let sideLength = min(image.size.width, image.size.height)

      let sourceSize = image.size
      let xOffset = (sourceSize.width - sideLength) / 2.0
      let yOffset = (sourceSize.height - sideLength) / 2.0

      let cropRect = CGRect(x: xOffset, y: yOffset, width: sideLength, height: sideLength).integral

      // Center crop the image
      let sourceCGImage = image.cgImage!
      let croppedCGImage = sourceCGImage.cropping(to: cropRect)!

      let croppedImage = UIImage(cgImage: croppedCGImage,
                                 scale: image.imageRendererFormat.scale,
                                 orientation: image.imageOrientation)

      print("CROPPED IMAGE SIZE: ", croppedImage.size)
      parent.selectedImage = croppedImage
        if croppedImage.pngData()?.count ?? 0 > 0 {
            picker.dismiss(animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("PICKER: \(picker)")
      parent.cancelHandler()
      picker.dismiss(animated: true)
    }
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = context.coordinator
    switch mode {
    case .takePhoto:
      picker.sourceType = .camera
    case .openPhotos:
      picker.sourceType = .photoLibrary
    }
    picker.videoQuality = .typeHigh
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
