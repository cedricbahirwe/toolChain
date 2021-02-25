//
//  ImagePickerView.swift
//  SocialMedia
//
//  Created by Cédric Bahirwe on 25/02/2021.
//

import Foundation
import SwiftUI
import UIKit
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var onCancelPicking: (() -> ()) = {}
    var onFinishPicking: (() -> ()) = {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancelPicking()
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
           
            parent.onFinishPicking()

            parent.presentationMode.wrappedValue.dismiss()
            
            if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    let asset = result.firstObject
                    print(asset?.value(forKey: "filename"))

                }


        }
    }
    
}
