//
//  HomeViewController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/18/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  let topStackView = TopNavigationStackView()
  let cardsDeckView = UIView()
  let buttonsStackView = HomeBottomControlsStackView()
  
  let cardViewModels = [ User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c").toCardViewModel(),
                         User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c").toCardViewModel() ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupDummyCards()
  }
  
  // MARK: - Private methods
  
  private func setupLayout() {
    let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
    overallStackView.axis = .vertical
    view.addSubview(overallStackView)
    overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    overallStackView.isLayoutMarginsRelativeArrangement = true
    overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
    overallStackView.bringSubviewToFront(cardsDeckView)
  }
  
  private func setupDummyCards() {
    cardViewModels.forEach { (cardViewModel) in
      let cardView = CardView(frame: .zero)
      cardView.imageView.image = UIImage(named: cardViewModel.imageName)
      cardView.informationLabel.attributedText = cardViewModel.attributedString
      cardView.informationLabel.textAlignment = cardViewModel.textAlignment
    
      cardsDeckView.addSubview(cardView)
      cardView.fillSuperview()
    }
  }
}

