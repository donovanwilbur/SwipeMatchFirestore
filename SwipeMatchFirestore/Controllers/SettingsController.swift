//
//  SettingsController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 2/20/19.
//  Copyright © 2019 Donovan Wilbur. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController {
  var imageButton: UIButton?
}

class SettingsController: UITableViewController {
  
  lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
  lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
  lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
  
  @objc func handleSelectPhoto(button: UIButton) {
    print("Selecting photo with button: \(button)")
    let imagePicker = CustomImagePickerController()
    imagePicker.imageButton = button
    imagePicker.delegate = self
    present(imagePicker, animated: true)
  }
  
  func createButton(selector: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle("Select Photo", for: .normal)
    button.backgroundColor = .white
    button.addTarget(self, action: selector, for: .touchUpInside)
    button.imageView?.contentMode = .scaleAspectFill
    button.layer.cornerRadius = 8
    button.clipsToBounds = true
    return button
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationItems()
    tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tableView.tableFooterView = UIView()
    tableView.keyboardDismissMode = .interactive
    
    fetchCurrentUser()
  }
  
  var user: User?
  
  private func fetchCurrentUser() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let dictionary = snapshot?.data() else { return }
      self.user = User(dictionary: dictionary)
      self.loadUserPhotos()
      
      self.tableView.reloadData()
    }
  }
  
  private func loadUserPhotos() {
    guard let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) else { return }
    SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
      self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
  }
  
  lazy var header: UIView = {
    let header = UIView()
    header.addSubview(image1Button)
    let padding: CGFloat = 16
    image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
    image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
    
    let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = padding
    
    header.addSubview(stackView)
    stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    return header
  }()
  
  class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
      super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      return header
    }
    let headerLabel = HeaderLabel()
    headerLabel.font = .boldSystemFont(ofSize: 16)
    switch section {
    case 1: headerLabel.text = "Name"
    case 2: headerLabel.text = "Profession"
    case 3: headerLabel.text = "Age"
    default: headerLabel.text = "Bio"
    }
    return headerLabel
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 300
    }
    return 40
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 0 : 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = SettingsCell(style: .default, reuseIdentifier: nil)
    
    switch indexPath.section {
    case 1:
      cell.textField.placeholder = "Enter Name"
      cell.textField.text = user?.name
      cell.textField.addTarget(self, action: #selector(handleNameChange(_:)), for: .editingChanged)
    case 2:
      cell.textField.placeholder = "Enter Profession"
      cell.textField.text = user?.profession
      cell.textField.addTarget(self, action: #selector(handleProfessionChange(_:)), for: .editingChanged)
    case 3:
      cell.textField.placeholder = "Enter Age"
      if let age = user?.age {
        cell.textField.text = "\(age)"
      }
      cell.textField.addTarget(self, action: #selector(handleAgeChange(_:)), for: .editingChanged)
    default:
      cell.textField.placeholder = "Enter Bio"
    }
    
    return cell
  }
  
  @objc private func handleNameChange(_ textField: UITextField) {
    self.user?.name = textField.text
  }
  
  @objc private func handleProfessionChange(_ textField: UITextField) {
    self.user?.profession = textField.text
  }
  
  @objc private func handleAgeChange(_ textField: UITextField) {
    self.user?.age = Int(textField.text ?? "")
  }
  
  private func setupNavigationItems() {
    navigationItem.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItems = [ UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
                                           UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel)) ]
  }
  
  @objc private func handleCancel() {
    dismiss(animated: true)
  }
  
  @objc private func handleSave() {
    print("Save button pressed")
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let docData: [String: Any] = [ "uid": uid,
                                   "fullName": user?.name ?? "",
                                   "imageUrl1": user?.imageUrl1 ?? "",
                                   "age": user?.age ?? -1,
                                   "profession": user?.profession ?? "" ]
    
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Saving settings"
    hud.show(in: view)
    Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
      hud.dismiss()
      if let error = error {
        print("Failed to save user settings. \(error.localizedDescription)")
        return
      }
      
      print("Finished saving user info.")
    }
  }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage = info[.originalImage] as? UIImage
    let imageButton = (picker as? CustomImagePickerController)?.imageButton
    imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    dismiss(animated: true)
  }
  
}
