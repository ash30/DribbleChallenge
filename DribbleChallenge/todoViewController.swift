//
//  todoViewController.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 09/05/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CAAnimationDelegate {
    
    var tableView: UITableView!
    var data = Array(0...10)
    
    override func viewDidLoad() {
        let view = UITableView()
        self.view.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        view.dataSource = self
        view.delegate = self
        tableView = view 
        
    }
    
    // MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test \(data[indexPath.item])"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // MARK: TABLEVIEW DELEGATE
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        data.remove(at: anim.value(forKey: "index") as! Int)
        tableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
            animation.toValue = CGPoint(x: cell!.center.x, y: tableView.bounds.height)
            animation.delegate = self
            animation.setValue(indexPath.item, forKey: "index")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            cell?.layer.add(animation, forKey: nil)
            CATransaction.commit()

        }
        
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.toValue = CATransform3DMakeScale(1.1, 1.2, 2)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        cell?.layer.add(animation, forKey: nil)
        
        CATransaction.commit()
        
    }
    
    
}
