//
//  CardView.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/19/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

class CardView: UIView {

  var cardViewModel: CardViewModel! {
    didSet {
      imageView.image = UIImage(named: cardViewModel.imageName)
      informationLabel.attributedText = cardViewModel.attributedString
      informationLabel.textAlignment = cardViewModel.textAlignment
    }
  }
  private let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
  private let informationLabel = UILabel()
  
  // Configurations
  private let threshold: CGFloat = 100
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 10
    clipsToBounds = true
    
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
    imageView.fillSuperview()
    
    addSubview(informationLabel)
    informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    informationLabel.text = "Test Name Test Name Age"
    informationLabel.textColor = .white
    informationLabel.font = .systemFont(ofSize: 34, weight: .heavy)
    informationLabel.numberOfLines = 0
    
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
      handleEnded(gesture)
    default:
      break
    }
  }
  
  private func handleChanged(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    let degrees: CGFloat = translation.x / 20
    let angle = degrees * .pi / 180
    
    let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
    self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
  }
  
  private func handleEnded(_ gesture: UIPanGestureRecognizer) {
    let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
    let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
    
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
      
      if shouldDismissCard {
        self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
      } else {
        self.transform = .identity
      }
    }, completion: { _ in
      self.transform = .identity
      if shouldDismissCard {
        self.removeFromSuperview()
      }
      //self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
    })
  }
  
}
