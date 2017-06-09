//
//  TodoTableSectionHeader.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 03/06/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class TodoTableSectionView: UIView {
    
    let textfield: UITextField = {
        let v = UITextField()
        v.placeholder = "Add New Goal"
        v.textColor = UIColor.black
        return v
    }()
    
    let addButton:UIButton = {
        let v = UIButton()
        v.setTitle("+", for: .normal)
        v.setContentHuggingPriority(750, for: .horizontal)
        v.setTitleColor(UIColor.black, for: .normal)
        return v
    }()
    
    let contentView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        return textfield.intrinsicContentSize
    }
    
    func createSubviews() {
        
        let parentView: UIView = {
            let v = contentView
            v.backgroundColor = UIColor.white

            v.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                v.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
                v.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
                v.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
            self.addSubview(v)
            NSLayoutConstraint.activate(constraints)
            return v
        }()
        
        let stackView = {
            let v = UIStackView(arrangedSubviews: [addButton,textfield])
            v.distribution = .fill
            v.alignment = .center
            v.axis = .horizontal
            
            v.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                v.topAnchor.constraint(equalTo: parentView.layoutMarginsGuide.topAnchor),
                v.bottomAnchor.constraint(equalTo: parentView.layoutMarginsGuide.bottomAnchor),
                v.leftAnchor.constraint(equalTo: parentView.layoutMarginsGuide.leftAnchor),
                v.rightAnchor.constraint(equalTo: parentView.layoutMarginsGuide.rightAnchor)
            ]
            parentView.addSubview(v)
            NSLayoutConstraint.activate(constraints)
        }()
        
       
        
    }
    
}
