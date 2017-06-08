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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    

    
    func createSubviews() {
        
        let v = UIStackView(arrangedSubviews: [addButton,textfield])
        addSubview(v)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            v.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            v.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            v.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        v.distribution = .fill
        v.alignment = .center
        v.axis = .horizontal

        
        
    }
    
}
