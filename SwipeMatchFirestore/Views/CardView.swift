//
//  CardView.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/19/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

class CardView: UIView {

  private let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 10
    clipsToBounds = true
    
    addSubview(imageView)
    imageView.fillSuperview()
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    addGestureRecognizer(panGesture)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func handlePan(gesture: UIPanGestureRecognizer) {
    
    switch gesture.state {
    case .changed:
      handleChanged(gesture)
    case .ended:
      handleEnded()
    default:
      break
    }
  }
  
  private func handleChanged(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
  }
  
  private func handleEnded() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
      self.transform = .identity
    })
  }
  
}
