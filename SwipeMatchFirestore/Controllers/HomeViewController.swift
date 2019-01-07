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
  
  let cardViewModels: [CardViewModel] = {
    let producers = [ User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c"),
                      User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c"),
                      Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster") ] as [ProducesCardViewModel]
    
    let viewModels = producers.map({return $0.toCardViewModel()})
    return viewModels
  }()
  
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
      cardView.cardViewModel = cardViewModel
      cardsDeckView.addSubview(cardView)
      cardView.fillSuperview()
    }
  }
}

