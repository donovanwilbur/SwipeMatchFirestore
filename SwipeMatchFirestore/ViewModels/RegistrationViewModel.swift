//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 1/17/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import UIKit

class RegistrationViewModel {
  
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
  
  private func checkFormValidity() {
    let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    isFormValidObserver?(isFormValid)
  }
  
  // Reactive programming
  var isFormValidObserver: ((Bool) -> Void)?
}

