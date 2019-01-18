//
//  Bindable.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 1/18/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import Foundation

class Bindable<T> {
  var value: T? {
    didSet {
      observer?(value)
    }
  }
  
  var observer: ((T?) -> Void)?
  
  func bind(observer: @escaping (T?) -> Void) {
    self.observer = observer
  }
}
