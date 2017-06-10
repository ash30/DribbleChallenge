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
    
    // MARK: PROPERTIES
    
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
    
    let confirmButton:UIButton = {
        let v = UIButton()
        v.setTitle("add", for: .normal)
        v.setContentHuggingPriority(750, for: .horizontal)
        v.setTitleColor(UIColor.black, for: .normal)
        v.isHidden = true
        return v
    }()
    
    let contentView: UIView = UIView()
    
    var contentViewWidthConstraint : NSLayoutConstraint?
    var contentViewHeightMinimumConstraint: NSLayoutConstraint?
    
    // MARK: METHODS
    
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
        
        contentViewHeightMinimumConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
        NSLayoutConstraint.activate([contentViewHeightMinimumConstraint!])
        
        let parentView: UIView = {
            let v = contentView
            v.backgroundColor = UIColor.white

            v.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                v.centerYAnchor.constraint(equalTo: centerYAnchor),
                v.centerXAnchor.constraint(equalTo: centerXAnchor),
                v.widthAnchor.constraint(equalTo: widthAnchor),
                v.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
            ]
            self.addSubview(v)
            NSLayoutConstraint.activate(constraints)
            // Save reference so we can animate later
            self.contentViewWidthConstraint = constraints[2]
            return v
        }()
        
        let stackView = {
            let v = UIStackView(arrangedSubviews: [addButton,textfield, confirmButton])
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
