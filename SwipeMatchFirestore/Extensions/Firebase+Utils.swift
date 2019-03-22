//
//  Firebase+Utils.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 3/22/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import Firebase

enum FirestoreError: Error {
  case uidDoesntExist
}

extension Firestore {
  
  func fetchCurrentUser(completion: @escaping (User?, Error?) -> Void) {
    guard let uid = Auth.auth().currentUser?.uid else {
      completion(nil, FirestoreError.uidDoesntExist)
      return
    }
    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let dictionary = snapshot?.data() else { return }
      let user = User(dictionary: dictionary)
      completion(user, nil)
    }
  }
}

