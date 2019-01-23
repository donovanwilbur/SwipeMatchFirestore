//
//  HomeController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/18/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

  let topStackView = TopNavigationStackView()
  let cardsDeckView = UIView()
  let buttonsStackView = HomeBottomControlsStackView()
  
  var cardViewModels = [CardViewModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    
    setupLayout()
    setupUserCards()
    fetchUsersFromFirestore()
  }
  
  @objc func handleSettings() {
    let registrationController = RegistrationController()
    present(registrationController, animated: true)
  }
  
  // MARK: - Private methods
  
  private func fetchUsersFromFirestore() {
    let query = Firestore.firestore().collection("users").whereField("age", isEqualTo: 24)
    query.getDocuments { (snapshot, error) in
      
      if let error = error {
        return
      }
      
      snapshot?.documents.forEach({ (documentSnapshot) in
        let userDictionary = documentSnapshot.data()
        let user = User(dictionary: userDictionary)
        self.cardViewModels.append(user.toCardViewModel())
      })
      self.setupUserCards()
    }
  }
  
  private func setupLayout() {
    view.backgroundColor = .white
    let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
    overallStackView.axis = .vertical
    view.addSubview(overallStackView)
    overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    overallStackView.isLayoutMarginsRelativeArrangement = true
    overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
    overallStackView.bringSubviewToFront(cardsDeckView)
  }
  
  private func setupUserCards() {
    cardViewModels.forEach { (cardViewModel) in
      let cardView = CardView(frame: .zero)
      cardView.cardViewModel = cardViewModel
      cardsDeckView.addSubview(cardView)
      cardView.fillSuperview()
    }
  }
}

