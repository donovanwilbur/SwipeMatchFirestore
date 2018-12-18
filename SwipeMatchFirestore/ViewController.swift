//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Donovan Wilbur on 12/18/18.
//  Copyright © 2018 Donovan Wilbur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let subviews = [UIColor.gray, UIColor.darkGray, UIColor.black].map { (color) -> UIView in
      let view = UIView()
      view.backgroundColor = color
      return view
    }
    
    let topStackView = UIStackView(arrangedSubviews: subviews)
    topStackView.distribution = .fillEqually
    topStackView.backgroundColor = .red
    topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    let blueView = UIView()
    blueView.backgroundColor = .blue
    
    let yellowView = UIView()
    yellowView.backgroundColor = .yellow
    yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    
    let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, yellowView])
    stackView.axis = .vertical
    
    view.addSubview(stackView)
    stackView.frame = .init(x: 0, y: 0, width: 300, height: 200)
    stackView.fillSuperview()
  }


}

