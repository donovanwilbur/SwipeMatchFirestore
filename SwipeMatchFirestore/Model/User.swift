//
//  User.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/20/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
  
  var name: String?
  var age: Int?
  var profession: String?
  var imageUrl1: String?
  var imageUrl2: String?
  var imageUrl3: String?
  var uid: String?
  
  init(dictionary: [String: Any]) {
    age = dictionary["age"] as? Int
    profession = dictionary["profession"] as? String
    name = dictionary["fullName"] as? String
    imageUrl1 = dictionary["imageUrl1"] as? String
    imageUrl2 = dictionary["imageUrl2"] as? String
    imageUrl3 = dictionary["imageUrl3"] as? String
    uid = dictionary["uid"] as? String
  }
  
  func toCardViewModel() -> CardViewModel {
    let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
    
    let ageString = age != nil ? "\(age!)" : "N/A"
    attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
    
    let professionString = profession != nil ? profession! : "Not available"
    attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
    
    var imageUrls = [String]()
    if let url = imageUrl1 { imageUrls.append(url) }
    if let url = imageUrl2 { imageUrls.append(url) }
    if let url = imageUrl3 { imageUrls.append(url) }
    
    return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
  }
  
}
