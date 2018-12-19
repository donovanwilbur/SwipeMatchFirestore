//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/18/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let topStackView = TopNavigationStackView()
  let cardsDeckView = UIView()
  let buttonsStackView = HomeBottomControlsStackView()
  
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
    let cardView = CardView()
    cardsDeckView.addSubview(cardView)
    cardView.fillSuperview()
  }
}

