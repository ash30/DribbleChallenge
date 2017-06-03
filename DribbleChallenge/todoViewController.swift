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
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("Selected Cell Index Doesn't exist in table")
            return
        }
        
        guard let coverImage = cell.contentView.resizableSnapshotView(from: cell.bounds, afterScreenUpdates: true, withCapInsets: .zero) else {
            
            print("Snapshot Failed")
            return
        }
        cell.superview!.addSubview(coverImage)
        coverImage.frame = cell.frame
        cell.contentView.isHidden = true

        
        CATransaction.begin()
        CATransaction.setCompletionBlock {

            self.data.remove(at: indexPath.item)
            tableView.deleteRows(at:[indexPath], with:.bottom)
            
            UIView.animate(withDuration: 1.0, animations: {
                coverImage.transform = coverImage.transform.translatedBy(x: 0, y: tableView.bounds.height)
            }){ (Bool) in
                coverImage.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            coverImage.transform = coverImage.transform.scaledBy(x: 1.1, y: 1)
        })
        CATransaction.commit()
        
    }
    
    
}
