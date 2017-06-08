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
    
    var tableView: UITableView!
    var data = Array(0...10)
    
    var headerHeight = 50.0
    
    var header: TodoTableSectionView?
    var constraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        
        
        let containingView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant:35),
                view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
            ]
            self.view.addSubview(view)
            NSLayoutConstraint.activate(constraints)
            return view
        }()
        
        tableView = {
            let view = UITableView()
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                view.topAnchor.constraint(equalTo: containingView.layoutMarginsGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: containingView.layoutMarginsGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: containingView.layoutMarginsGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: containingView.layoutMarginsGuide.trailingAnchor)
            ]
            
            containingView.addSubview(view)
            NSLayoutConstraint.activate(constraints)
            view.dataSource = self
            view.delegate = self
            return view
        }()
        
        view.backgroundColor = UIColor.red
        tableView.backgroundColor = UIColor.blue
        tableView.clipsToBounds = false
        
    }
    
    // MARK: TEXT DELEGATE 
    func textFieldDidBeginEditing(_ textField: UITextField){
        self.headerHeight = 100
        constraints[0].constant = 100

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            
            print("test \(self.header?.frame)")
            //self.tableView?.beginUpdates()
            //self.tableView?.endUpdates()


        }
        

        UIView.animate(withDuration: 0.3, animations: {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            self.tableView.layoutIfNeeded()

        } )
        
        CATransaction.commit()
        
    }
    /*
 
     I think what happens is we're not animating the header view widget height
     JUST the height the table uses to calculate offset ( which is working! )
     
     For some reason this doesn't affect the view widget
     THEN when we next click on the thing, it jumps to what is was supposed to be
     
     EDIT: So we fixed the jumping - we needed to force the constraints to resolve
     after the height change so they too get implicitly animated
     
     Problem persists though:
     
        On edit: the frame is updating new header height,
        on exit: the frame updates to old height, NOT new height
        On subsequent edits, layout keeps using old height
     
    */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        

        self.headerHeight = 50
        constraints[0].constant = 50
        constraints[0].firstAttribute

        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            //self.tableView.reloadData()
            print("test \(self.header?.frame)")

            

        }
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            self.tableView.layoutIfNeeded()

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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = TodoTableSectionView()
        header = v
        v.textfield.delegate = self
        
        //v.translatesAutoresizingMaskIntoConstraints = false
        v.autoresizingMask = [
            .flexibleWidth,
        ]
        
        constraints = [
            v.heightAnchor.constraint(equalToConstant: CGFloat(headerHeight))
        ]
        NSLayoutConstraint.activate(constraints)

        
        return v
    }
    

    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headerHeight)

    }
    

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
        coverImage.layer.zPosition = 100.0
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
        
        UIView.animate(withDuration: 0.3, animations: {
            coverImage.transform = coverImage.transform.scaledBy(x: 1.1, y: 1)
        })
                
        CATransaction.commit()
        
    }
    
    
}
