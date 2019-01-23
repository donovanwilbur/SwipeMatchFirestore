//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 1/17/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
  
  var bindableIsRegistering = Bindable<Bool>()
  var bindableImage = Bindable<UIImage>()
  var bindableIsFormValid = Bindable<Bool>()

  var fullName: String? {
    didSet {
      checkFormValidity()
    }
  }
  
  var email: String? {
    didSet {
      checkFormValidity()
    }
  }
  
  var password: String? {
    didSet {
      checkFormValidity()
    }
  }
  
  func performRegistration(completion: @escaping (Error?) -> Void) {
    guard let email = email, let password = password else { return }
    
    bindableIsRegistering.value = true
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      
      if let error = error {
        completion(error)
        return
      }
      
      self.saveImageToFirebase(completion: completion)
    }
  }
  
  private func saveImageToFirebase(completion: @escaping (Error?) -> Void) {
    let filename = UUID().uuidString
    let reference = Storage.storage().reference(withPath: "/images/\(filename)")
    let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
    reference.putData(imageData, metadata: nil, completion: { (_, error) in
      
      if let error = error {
        completion(error)
        return
      }
      
      print("Finished uploading image to storage")
      reference.downloadURL(completion: { (url, error) in
        
        if let error = error {
          completion(error)
          return
        }
        
        print("Download url of our image is: \(url?.absoluteString ?? "")")
        self.bindableIsRegistering.value = false
        
        let imageUrl = url?.absoluteString ?? ""
        self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
      })
    })
  }
  
  private func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> Void) {
    let uid = Auth.auth().currentUser?.uid ?? ""
    let documentData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1": imageUrl]
    Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
      if let error = error {
        completion(error)
        return
      }
      
      completion(nil)
    }
  }
  
  private func checkFormValidity() {
    let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    bindableIsFormValid.value = isFormValid
  }
}

