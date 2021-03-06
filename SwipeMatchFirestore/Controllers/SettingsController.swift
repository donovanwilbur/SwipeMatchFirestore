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

protocol SettingsControllerDelegate: class {
  func didSaveSettings()
}

class CustomImagePickerController: UIImagePickerController {
  var imageButton: UIButton?
}

class SettingsController: UITableViewController {
  
  lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
  lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
  lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
  
  weak var delegate: SettingsControllerDelegate?
  
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
    Firestore.firestore().fetchCurrentUser { (user, error) in
      if let error = error {
        print("Failed to fetch user:", error)
        return
      }
      self.user = user
      self.loadUserPhotos()
      self.tableView.reloadData()
    }
  }
  
  private func loadUserPhotos() {
    if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
        self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      }
    }
    
    if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
        self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      }
    }
    
    if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
        self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      }
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
    case 4: headerLabel.text = "Bio"
    default: headerLabel.text = "Seeking Age Range"
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
    return 6
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 0 : 1
  }
  
  @objc private func handleMinAgeChange(slider: UISlider) {
    evaluateMinMax()
  }
  
  @objc private func handleMaxAgeChange(slider: UISlider) {
    evaluateMinMax()
  }
  
  private func evaluateMinMax() {
    guard let ageRangeCell = tableView.cellForRow(at: IndexPath(item: 0, section: 5)) as? AgeRangeCell else { return }
    let minValue = Int(ageRangeCell.minSlider.value)
    var maxValue = Int(ageRangeCell.maxSlider.value)
    maxValue = max(minValue, maxValue)
    ageRangeCell.maxSlider.value = Float(maxValue)
    ageRangeCell.minLabel.text = "Min \(minValue)"
    ageRangeCell.maxLabel.text = "Max \(maxValue)"
    
    user?.minSeekingAge = minValue
    user?.maxSeekingAge = maxValue
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 5 {
      let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
      ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
      ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
      ageRangeCell.minLabel.text = "\(user?.minSeekingAge ?? -1)"
      ageRangeCell.maxLabel.text = "\(user?.maxSeekingAge ?? -1)"
      return ageRangeCell
    }
    
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
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let docData: [String: Any] = [ "uid": uid,
                                   "fullName": user?.name ?? "",
                                   "imageUrl1": user?.imageUrl1 ?? "",
                                   "imageUrl2": user?.imageUrl2 ?? "",
                                   "imageUrl3": user?.imageUrl3 ?? "",
                                   "age": user?.age ?? -1,
                                   "profession": user?.profession ?? "",
                                   "minSeekingAge": user?.minSeekingAge ?? -1,
                                   "maxSeekingAge": user?.maxSeekingAge ?? -1]
    
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Saving settings"
    hud.show(in: view)
    Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
      hud.dismiss()
      if let error = error {
        print("Failed to save user settings. \(error.localizedDescription)")
        return
      }
      
      self.dismiss(animated: true, completion: {
        self.delegate?.didSaveSettings()
      })
    }
  }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage = info[.originalImage] as? UIImage
    let imageButton = (picker as? CustomImagePickerController)?.imageButton
    imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    dismiss(animated: true)
    
    let filename = UUID().uuidString
    let ref = Storage.storage().reference(withPath: "/images/\(filename)")
    guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
    
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Uploading image..."
    hud.show(in: view)
    ref.putData(uploadData, metadata: nil) { (nil, error) in
      if let error = error {
        print("Failed to upload image to storage. \(error.localizedDescription)")
        return
      }
      
      print("Finished uploading image")
      ref.downloadURL(completion: { (url, error) in
        hud.dismiss()

        if let error = error {
          print("Failed to retrieve download URL. \(error.localizedDescription)")
          return
        }
        
        print("Finished getting download url. \(url?.absoluteString ?? "")")
        if imageButton == self.image1Button {
          self.user?.imageUrl1 = url?.absoluteString
        } else if imageButton == self.image2Button {
          self.user?.imageUrl2 = url?.absoluteString
        } else if imageButton == self.image3Button {
          self.user?.imageUrl3 = url?.absoluteString
        }
      })
    }
  }
  
}
