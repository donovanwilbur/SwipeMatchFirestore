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
      let imageName = cardViewModel.imageNames.first ?? ""
      imageView.image = UIImage(named: imageName)
      informationLabel.attributedText = cardViewModel.attributedString
      informationLabel.textAlignment = cardViewModel.textAlignment
      
      (0..<cardViewModel.imageNames.count).forEach { (_) in
        let barView = UIView()
        barView.backgroundColor = barDeselectedColor
        barsStackView.addArrangedSubview(barView)
      }
      barsStackView.arrangedSubviews.first?.backgroundColor = .white
    
      setupImageIndexObserver()
    }
  }
  
  private let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
  private let informationLabel = UILabel()
  private let gradientLayer = CAGradientLayer()
  private let barsStackView = UIStackView()
  private var imageIndex = 0
  private let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
  
  // Configurations
  private let threshold: CGFloat = 100
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    addGestureRecognizer(panGesture)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupImageIndexObserver() {
    cardViewModel.imageIndexObserver = { [unowned self] (index, image) in
      self.imageView.image = image
      self.barsStackView.arrangedSubviews.forEach { $0.backgroundColor = self.barDeselectedColor }
      self.barsStackView.arrangedSubviews[index].backgroundColor = .white
    }
  }
  
  private func setupLayout() {
    layer.cornerRadius = 10
    clipsToBounds = true
    
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
    imageView.fillSuperview()
    
    setupBarsStackView()
    
    // add a gradient layer
    setupGradientLayer()
    
    addSubview(informationLabel)
    informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    informationLabel.textColor = .white
    informationLabel.numberOfLines = 0
  }
  
  private func setupBarsStackView() {
    addSubview(barsStackView)
    barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    barsStackView.spacing = 4
    barsStackView.distribution = .fillEqually
  }
  
  private func setupGradientLayer() {
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    gradientLayer.locations = [0.5, 1.1]
    layer.addSublayer(gradientLayer)
  }
  
  override func layoutSubviews() {
    gradientLayer.frame = self.frame
  }
  
  @objc private func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.location(in: nil)
    let shouldAdvanceToNextPhoto = tapLocation.x > (frame.width / 2) ? true : false

    if shouldAdvanceToNextPhoto {
      cardViewModel.advanceToNextPhoto()
    } else {
      cardViewModel.goToPreviousPhoto()
    }
  }
  
  @objc private func handlePan(gesture: UIPanGestureRecognizer) {
    
    switch gesture.state {
    case .began:
      superview?.subviews.forEach({ (subview) in
        subview.layer.removeAllAnimations()
      })
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
    })
  }
}
