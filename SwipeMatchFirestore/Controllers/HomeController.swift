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
  
  private var user: User?
  private let hud = JGProgressHUD(style: .dark)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    
    setupLayout()
    fetchCurrentUser()
  }
  
  @objc func handleSettings() {
    let settingsController = SettingsController()
    settingsController.delegate = self
    let navController = UINavigationController(rootViewController: settingsController)
    present(navController, animated: true)
  }
  
  // MARK: - Private methods
  
  private func fetchCurrentUser() {
    hud.textLabel.text = "Loading"
    hud.show(in: view)
    cardsDeckView.subviews.forEach { $0.removeFromSuperview() }
    
    Firestore.firestore().fetchCurrentUser { (user, error) in
      if let error = error {
        print("Failed to fetch user:", error)
        self.hud.dismiss()
        return
      }
      self.user = user
      self.fetchUsersFromFirestore()
    }
  }
  
  private func fetchUsersFromFirestore() {
    guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
    
    //Fetch users with pagination
    let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
    query.getDocuments { (snapshot, error) in
      self.hud.dismiss()
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

// MARK: - SettingsControllerDelegate Methods
// MARK: -
extension HomeController: SettingsControllerDelegate {
  func didSaveSettings() {
    fetchCurrentUser()
  }
}
