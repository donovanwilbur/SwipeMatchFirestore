//
//  RegistrationController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 1/16/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
  
  // UI Components
  let selectPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Select Photo", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    button.backgroundColor = .white
    button.setTitleColor(.black, for: .normal)
    button.heightAnchor.constraint(equalToConstant: 275).isActive = true
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(handleSelectPhotoBtnPressed), for: .touchUpInside)
    return button
  }()
  
  let fullNameTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24, height: 44)
    textField.placeholder = "Enter full name"
    textField.backgroundColor = .white
    return textField
  }()
  
  let emailTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24, height: 44)
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    textField.backgroundColor = .white
    return textField
  }()
  
  let passwordTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24, height: 44)
    textField.placeholder = "Enter password"
    textField.isSecureTextEntry = true
    textField.backgroundColor = .white
    return textField
  }()
  
  let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Register", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    button.backgroundColor = #colorLiteral(red: 0.8135682344, green: 0.1019940302, blue: 0.3355026245, alpha: 1)
    button.setTitleColor(.white, for: .normal)
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.layer.cornerRadius = 22
    button.addTarget(self, action: #selector(handleRegisterBtnPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var verticalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, registerButton])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    return stackView
  }()

  lazy var overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
  
  let gradientLayer = CAGradientLayer()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupGradientLayer()
    setupLayout()
    setupNotificationObservers()
    setupTapGesture()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    overallStackView.axis = self.traitCollection.verticalSizeClass == .compact ? .horizontal : .vertical
  }
  
  // MARK: - Private Methods
  
  private func setupTapGesture() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
  }
  
  private func setupNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupLayout() {
    view.addSubview(overallStackView)
    overallStackView.axis = .horizontal
    selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
    overallStackView.spacing = 10
    overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    gradientLayer.frame = view.bounds
  }
  
  private func setupGradientLayer() {
    let topColor = #colorLiteral(red: 1, green: 0.2886515856, blue: 0.3460421562, alpha: 1)
    let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.locations = [0, 1]
    view.layer.addSublayer(gradientLayer)
    gradientLayer.frame = view.bounds
  }
  
  @objc private func handleTapDismiss() {
    self.view.endEditing(true)
  }
  
  @objc private func handleKeyboardShow(notification: Notification) {
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardFrame = value.cgRectValue
    print(keyboardFrame)
    
    let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
    print(bottomSpace)
    
    let difference = keyboardFrame.height - bottomSpace
    self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
  }
  
  @objc private func handleKeyboardHide(notification: Notification) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.view.transform = .identity
    })
  }
  
  @objc private func handleSelectPhotoBtnPressed() {
    print("Sub to Pewds")
  }
  
  @objc private func handleRegisterBtnPressed() {
    print("Sub to Pewdiepie")
  }
}
