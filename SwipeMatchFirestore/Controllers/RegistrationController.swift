//
//  RegistrationController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 1/16/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
  
  // UI Components
  let selectPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Select Photo", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    button.backgroundColor = .white
    button.setTitleColor(.black, for: .normal)
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(handleSelectPhotoBtnPressed), for: .touchUpInside)
    button.imageView?.contentMode = .scaleAspectFill
    button.clipsToBounds = true
    return button
  }()
  
  lazy var selectPhotoButtonWidthAnchor = selectPhotoButton.widthAnchor.constraint(equalToConstant: 275)
  lazy var selectPhotoButtonHeightAnchor = selectPhotoButton.heightAnchor.constraint(equalToConstant: 275)
  
  let fullNameTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24, height: 50)
    textField.placeholder = "Enter full name"
    textField.backgroundColor = .white
    textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    return textField
  }()
  
  let emailTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24, height: 50)
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    textField.autocapitalizationType = .none
    textField.backgroundColor = .white
    textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    return textField
  }()
  
  let passwordTextField: CustomTextField = {
    let textField = CustomTextField(padding: 24, height: 50)
    textField.placeholder = "Enter password"
    textField.isSecureTextEntry = true
    textField.backgroundColor = .white
    textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    return textField
  }()
  
  let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Register", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    button.setTitleColor(.gray, for: .disabled)
    button.backgroundColor = .lightGray
    button.isEnabled = false
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.layer.cornerRadius = 22
    button.addTarget(self, action: #selector(handleRegisterBtnPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var verticalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, registerButton])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    return stackView
  }()

  lazy var overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
  
  let gradientLayer = CAGradientLayer()

  let registrationViewModel = RegistrationViewModel()
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupGradientLayer()
    setupLayout()
    setupTapGesture()
    setupRegistrationViewModelObserver()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupNotificationObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if self.traitCollection.verticalSizeClass == .compact {
      overallStackView.axis = .horizontal
      verticalStackView.distribution = .fillEqually
      selectPhotoButtonHeightAnchor.isActive = false
      selectPhotoButtonWidthAnchor.isActive = true
    } else {
      overallStackView.axis = .vertical
      verticalStackView.distribution = .fill
      selectPhotoButtonWidthAnchor.isActive = false
      selectPhotoButtonHeightAnchor.isActive = true
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    gradientLayer.frame = view.bounds
  }
  
  // MARK: - Private Methods
  
  private func setupRegistrationViewModelObserver() {
    registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
      guard let isFormValid = isFormValid else { return }
      
      self.registerButton.isEnabled = isFormValid
      if isFormValid {
        self.registerButton.backgroundColor = #colorLiteral(red: 0.8135682344, green: 0.1019940302, blue: 0.3355026245, alpha: 1)
        self.registerButton.setTitleColor(.white, for: .normal)
      } else {
        self.registerButton.backgroundColor = .lightGray
        self.registerButton.setTitleColor(.gray, for: .normal)
      }
    }
    
    registrationViewModel.bindableImage.bind { [unowned self] (image) in
      self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
      if isRegistering == true {
        self.registeringHUD.textLabel.text = "Register"
        self.registeringHUD.show(in: self.view)
      } else {
        self.registeringHUD.dismiss()
      }
    }
  }
  
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
    overallStackView.spacing = 12
    overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  private func setupGradientLayer() {
    let topColor = #colorLiteral(red: 1, green: 0.2886515856, blue: 0.3460421562, alpha: 1)
    let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.locations = [0, 1]
    view.layer.addSublayer(gradientLayer)
    gradientLayer.frame = view.bounds
  }
  
  @objc private func handleTextChange(textField: UITextField) {
    if textField == fullNameTextField {
      registrationViewModel.fullName = textField.text
    } else if textField == emailTextField {
      registrationViewModel.email = textField.text
    } else {
      registrationViewModel.password = textField.text
    }
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
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    present(imagePickerController, animated: true)
  }
  
  let registeringHUD = JGProgressHUD(style: .dark)
  
  @objc private func handleRegisterBtnPressed() {
    self.handleTapDismiss()
    
    registrationViewModel.performRegistration { [weak self] (error) in
      if let error = error {
        self?.showHUDWithError(error: error)
        return
      }
      
      print("Finished registering our user.")
      
    }
  }
  
  private func showHUDWithError(error: Error) {
    registeringHUD.dismiss()
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Failed registration"
    hud.detailTextLabel.text = error.localizedDescription
    hud.show(in: self.view)
    hud.dismiss(afterDelay: 3)
  }
}

// MARK: - UIImagePickerControllerDelegate
// MARK: -
extension RegistrationController: UIImagePickerControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.originalImage] as? UIImage
    registrationViewModel.bindableImage.value = image
    //registrationViewModel.image = image
    dismiss(animated: true)
  }
}

// MARK: - UINavigationControllerDelegate
// MARK: -
extension RegistrationController: UINavigationControllerDelegate {
  
}
