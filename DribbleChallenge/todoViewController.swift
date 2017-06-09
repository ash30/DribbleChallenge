//
//  todoViewController.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 09/05/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    // MARK: PROPERTIES
    
    var tableView: UITableView!
    var data = Array(0...10)
    
    var headerHeight = 50.0
    
    var header: UIView?
    var constraints: [NSLayoutConstraint] = []
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        let containingView: UIStackView = {
            
            // Create parent view for styling
            let view = UIView()
            view.layer.cornerRadius = 4.0
            view.clipsToBounds = true
            
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant:35),
                view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
            ]
            self.view.addSubview(view)
            NSLayoutConstraint.activate(constraints)
            
            let stack = UIStackView()
            view.addSubview(stack)
            stack.distribution = .fill
            stack.alignment = .fill
            stack.axis = .vertical
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            let stackConstraints = [
                stack.topAnchor.constraint(equalTo: view.topAnchor),
                stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
            view.addSubview(stack)
            NSLayoutConstraint.activate(stackConstraints)
            
            return stack
        }()
        
        header = { () -> UIView in
            let view = TodoTableSectionView()
            view.backgroundColor = UIColor.blue
            view.textfield.delegate = self
            containingView.addArrangedSubview(view)
            return view
        }()
        
        
        tableView = {
            let view = UITableView()
            containingView.addArrangedSubview(view)
            view.dataSource = self
            view.delegate = self
            return view
        }()
        

        // Display Preferences
        view.backgroundColor = UIColor.red
        tableView.backgroundColor = UIColor.blue
    }
    
    
    // MARK: TEXT DELEGATE 
    func textFieldDidBeginEditing(_ textField: UITextField){

        let heightConstraints = header?.constraintsAffectingLayout(for: .vertical).filter { $0.firstAttribute == .height } ?? []
        
        heightConstraints.map { $0.constant = 100 }

        CATransaction.begin()
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            self.view.layoutIfNeeded()

        } )
        CATransaction.commit()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        

        let heightConstraints = header?.constraintsAffectingLayout(for: .vertical).filter { $0.firstAttribute == .height } ?? []
        heightConstraints.map { $0.constant = 50 }
        
        CATransaction.begin()
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            self.view.layoutIfNeeded()

        } )
        CATransaction.commit()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test \(data[indexPath.item])"
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.white
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
        guard let coverImage = tableView.createTableCellSnapshot(cell: cell) else {
            print("Snapshot Failed")
            return
        }
        coverImage.layer.cornerRadius = 5.0
        coverImage.clipsToBounds = true
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {

            // After focus animation - drop off screen
            cell.isHidden = true
            self.data.remove(at: indexPath.item)
            tableView.deleteRows(at:[indexPath], with:.bottom)
            UIView.animate(withDuration: 1.0, animations: {
                coverImage.transform = coverImage.transform.translatedBy(x: 0, y: tableView.bounds.height)
            }){ (Bool) in
                coverImage.removeFromSuperview()
            }
        }
        // Initial Animation
        UIView.animate(withDuration: 0.3, animations: {
            coverImage.transform = coverImage.transform.scaledBy(x: 1.1, y: 1)
            coverImage.layer.zPosition = 100.0
            
        })
        CATransaction.commit()
    }
    
}

extension UITableView {
    
    func createTableCellSnapshot(cell:UITableViewCell) -> UIView? {
        // Create a rastered image of a view and match its position
        
        // We need the table view to be attached to a view heirachy
        // So we can position the snapshot correctly
        guard
            let cellSuperView = cell.superview,
            let tableSuperView = superview
        else {
            return nil
        }
        
        // Better to animate Snap shot View ala Transition rather than mess with table cells
        guard let coverImage = cell.contentView.resizableSnapshotView(from: cell.bounds, afterScreenUpdates: true, withCapInsets: .zero) else {
            
            print("Snapshot Failed")
            return nil
        }

        tableSuperView.addSubview(coverImage)
        coverImage.frame = cellSuperView.convert(cell.frame, to: tableSuperView)
        return coverImage
        
    }
    
}
