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
    let textField = CustomTextField(padding: 24)
    textField.placeholder = "Enter full name"
    textField.backgroundColor = .white
    return textField
  }()
  
  let emailTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24)
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    textField.backgroundColor = .white
    return textField
  }()
  
  let passwordTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24)
    textField.placeholder = "Enter password"
    textField.isSecureTextEntry = true
    textField.backgroundColor = .white
    return textField
  }()
  
  let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Register", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    button.backgroundColor = #colorLiteral(red: 0.8135682344, green: 0.1019940302, blue: 0.3355026245, alpha: 1)
    button.setTitleColor(.white, for: .normal)
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.layer.cornerRadius = 25
    button.addTarget(self, action: #selector(handleRegisterBtnPressed), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupGradientLayer()
    
    let stackView = UIStackView(arrangedSubviews: [selectPhotoButton, fullNameTextField, emailTextField, passwordTextField, registerButton] )
    view.addSubview(stackView)
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  private func setupGradientLayer() {
    
    let gradientLayer = CAGradientLayer()
    let topColor = #colorLiteral(red: 1, green: 0.2886515856, blue: 0.3460421562, alpha: 1)
    let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.locations = [0, 1]
    
    view.layer.addSublayer(gradientLayer)
    gradientLayer.frame = view.bounds
  }
  
  @objc func handleSelectPhotoBtnPressed() {
    print("Sub to Pewds")
  }
  
  @objc func handleRegisterBtnPressed() {
    print("Sub to Pewdiepie")
  }
}
