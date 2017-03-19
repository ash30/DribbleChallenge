//
//  ViewController.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 16/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var dialer: UIDialerView!
    var backgroundColor = UIColor(colorLiteralRed: 0.14117, green: 0.09019, blue: 0.35294, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
    
        dialer = UIDialerView()
        dialer.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            dialer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            dialer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            dialer.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            dialer.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)


        ]
        view.addSubview(dialer)
        NSLayoutConstraint.activate(constraints)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

