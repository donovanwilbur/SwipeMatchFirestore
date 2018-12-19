//
//  TopNavigationStackView.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/19/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {

  let settingsButton = UIButton(type: .system)
  let messagesButton = UIButton(type: .system)
  let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    fireImageView.contentMode = .scaleAspectFit
    
    settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
    messagesButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
    
    [settingsButton, UIView(), fireImageView, UIView(), messagesButton].forEach { addArrangedSubview($0) }
    
    distribution = .equalCentering
    heightAnchor.constraint(equalToConstant: 60).isActive = true
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
  
  }

  required init(coder: NSCoder) {
    fatalError()
  }
  
}
