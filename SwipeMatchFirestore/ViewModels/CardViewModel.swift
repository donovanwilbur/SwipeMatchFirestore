//
//  CardViewModel.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/20/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
  func toCardViewModel() -> CardViewModel
}

class CardViewModel {
  
  let imageNames: [String]
  let attributedString: NSAttributedString
  let textAlignment: NSTextAlignment
  
  init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
    self.imageNames = imageNames
    self.attributedString = attributedString
    self.textAlignment = textAlignment
  }
  
  private var imageIndex = 0 {
    didSet {
      let imageUrl = imageNames[imageIndex]
      imageIndexObserver?(imageIndex, imageUrl)
    }
  }
  
  // Reactive Programming
  var imageIndexObserver: ((Int, String?) -> Void)?
  
  func advanceToNextPhoto() {
    imageIndex = min(imageIndex + 1, imageNames.count - 1)
  }
  
  func goToPreviousPhoto() {
    imageIndex = max(0, imageIndex - 1)
  }
}

