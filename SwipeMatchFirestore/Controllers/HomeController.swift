//
//  HomeController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/18/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {

  let topStackView = TopNavigationStackView()
  let cardsDeckView = UIView()
  let bottomControls = HomeBottomControlsStackView()
  
  var cardViewModels = [CardViewModel]()
  var lastFetchedUser: User?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    
    setupLayout()
    fetchUsersFromFirestore()
  }
  
  @objc func handleSettings() {
    let settingsController = SettingsController()
    let navController = UINavigationController(rootViewController: settingsController)
    present(navController, animated: true)
  }
  
  // MARK: - Private methods
  
  private func fetchUsersFromFirestore() {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Fetching Users"
    hud.show(in: view)
    
    //Fetch users with pagination
    let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
    query.getDocuments { (snapshot, error) in
      hud.dismiss()
      
      if let error = error {
        print(error)
        return
      }
      
      snapshot?.documents.forEach({ (documentSnapshot) in
        let userDictionary = documentSnapshot.data()
        let user = User(dictionary: userDictionary)
        self.cardViewModels.append(user.toCardViewModel())
        self.lastFetchedUser = user
        self.setupCardFromUser(user: user)
      })
    }
  }
  
  private func setupCardFromUser(user: User) {
    let cardView = CardView(frame: .zero)
    cardView.cardViewModel = user.toCardViewModel()
    cardsDeckView.addSubview(cardView)
    cardsDeckView.sendSubviewToBack(cardView)
    cardView.fillSuperview()
  }
  
  private func setupLayout() {
    view.backgroundColor = .white
    let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
    overallStackView.axis = .vertical
    view.addSubview(overallStackView)
    overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    overallStackView.isLayoutMarginsRelativeArrangement = true
    overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
    overallStackView.bringSubviewToFront(cardsDeckView)
  }
  
  @IBAction private func handleRefresh(_ sender: UIButton) {
    fetchUsersFromFirestore()
  }
}

