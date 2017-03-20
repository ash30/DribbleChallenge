//
//  ViewController.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 16/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var container: UIStackView!
    var keypad: UIDialerView!
    var pin: UIDialerView!
    var label: UILabel!
    
    var backgroundColor = UIColor(colorLiteralRed: 0.14117, green: 0.09019, blue: 0.35294, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
    
        container = {
            let v = UIStackView()
            v.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                v.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 64.0),
                v.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -64.0),
                v.leftAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leftAnchor),
                v.rightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.rightAnchor)
            ]
            self.view.addSubview(v)
            NSLayoutConstraint.activate(constraints)
            
            // NEED TO WORK OUT SIZE if we want to cleverly 
            v.distribution = .fillProportionally
            v.alignment = .fill
            v.axis = .vertical
            return v
        }()
        

        
        label = {
            let v = UILabel()
            v.text  = "TouchID or Enter PIN"
            v.textAlignment = .center
            v.textColor = UIColor.white

            container.addArrangedSubview(v)
            return v
        }()
        
        pin = { () -> UIDialerView in
            let v = UIDialerView()
            let subContainer = UIStackView()
            subContainer.addArrangedSubview(v)
            subContainer.alignment = .center
            subContainer.distribution = .fill
            subContainer.axis = .vertical

            
            v.rowCount = 4
            v.numItems = 4
            v.textSize = 5
            v.gradientDirection = .horizontal
            v.translatesAutoresizingMaskIntoConstraints = false
            container.addArrangedSubview(subContainer)
            return v
        }()
        
        keypad = { () -> UIDialerView in
            let v = UIDialerView()
            v.translatesAutoresizingMaskIntoConstraints = false
            container.addArrangedSubview(v)
            return v
        }()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

