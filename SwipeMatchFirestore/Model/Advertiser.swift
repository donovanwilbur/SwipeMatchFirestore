//
//  Advertiser.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 1/7/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import Foundation
import UIKit

struct Advertiser: ProducesCardViewModel {
  
  var title: String
  var brandName: String
  var posterPhotoName: String
  
  func toCardViewModel() -> CardViewModel {
    let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
    attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
    
    return CardViewModel(imageNames: [posterPhotoName], attributedString: attributedString, textAlignment: .center)
  }
}


