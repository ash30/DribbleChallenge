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

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.addSubview(gradientView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100)))
//        view.addSubview(gradientView(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100)))
    
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

