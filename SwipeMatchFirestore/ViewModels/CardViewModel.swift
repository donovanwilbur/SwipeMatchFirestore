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

struct CardViewModel {
  
  let imageNames: [String]
  let attributedString: NSAttributedString
  let textAlignment: NSTextAlignment
  
}

