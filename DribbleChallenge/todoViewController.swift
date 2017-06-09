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
    
    var header: TodoTableSectionView?
    
    private var containingView:UIStackView?
    
    private lazy var headerTransitionView:UIView? = {
        guard
            let header = self.header,
            let containingView = self.containingView,
            let view = header.contentView.positionedSnapshot(snapshotSuperView: header, afterScreenUpdates: true)
        else {
            return nil
        }
        return view
        
    }()
    
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        containingView = {
            
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
        
        header = { 
            let view = TodoTableSectionView()
            view.backgroundColor = UIColor.blue
            view.textfield.delegate = self
            view.addButton.addTarget(self, action: #selector(createRow), for: .touchDown)
            let constraints = [
                view.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
            ]
            NSLayoutConstraint.activate(constraints)
            containingView!.addArrangedSubview(view)
            return view
        }()
        
        tableView = {
            let view = UITableView()
            containingView!.addArrangedSubview(view)
            view.dataSource = self
            view.delegate = self
            return view
        }()

        // Display Preferences
        view.backgroundColor = UIColor.red
        tableView.backgroundColor = UIColor.blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // We create this here because snapshot needs views displayed
        // but we need it finished before any user interaction
        headerTransitionView?.isHidden = true
        headerTransitionView?.center.y += 50
        
    }
    
    // MARK: ROW CREATION
    @objc func createRow(){
        
        let firstIndex = IndexPath(item: 0, section: 0)
        
        guard let coverImage = header?.contentView.positionedSnapshot(snapshotSuperView:self.view) else {
            return
        }
        guard let initialCell = tableView.cellForRow(at: firstIndex) else {
            return
        }
        
        let heightConstraints = header?.constraintsAffectingLayout(for: .vertical).filter { $0.firstAttribute == .height } ?? []
        heightConstraints.map { $0.constant = 50 }
        
        header?.contentView.isHidden = true
        
        CATransaction.begin()

        UIView.animate(withDuration: 0.5, animations: {

            
            self.data.insert(0, at: 0)
            
            self.tableView?.beginUpdates()
            self.tableView.insertRows(at: [firstIndex], with: .top)
            self.tableView?.endUpdates()
            let newCell = self.tableView.cellForRow(at: firstIndex)
            newCell?.isHidden = true
            self.view.layoutIfNeeded()
            
            coverImage.transform = coverImage.transform.translatedBy(x: 0, y: 40.0)

        }){ (Bool) in
            let newCell = self.tableView.cellForRow(at: firstIndex)
            newCell?.isHidden = false
            coverImage.removeFromSuperview()
            
            // SLIDE UP TRANSITION
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.header?.contentView.isHidden = false
                self.headerTransitionView?.isHidden = true
            }
            self.headerTransitionView?.isHidden = false
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
            animation.byValue = CGPoint(x: 0, y: -50)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            self.headerTransitionView?.layer.add(animation, forKey: nil)
            CATransaction.commit()

            
        }
        
        CATransaction.commit()
        

        
    }
    
    // MARK: TEXT DELEGATE 
    func textFieldDidBeginEditing(_ textField: UITextField){

        let heightConstraints = header?.constraintsAffectingLayout(for: .vertical).filter { $0.firstAttribute == .height } ?? []
        _ = heightConstraints.map { $0.constant = 75 }

        CATransaction.begin()
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            self.view.layoutIfNeeded()

        } )
        CATransaction.commit()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        createRow()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: TABLEVIEW DELEGATE

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("Selected Cell Index Doesn't exist in table")
            return
        }
        guard let coverImage = cell.contentView.positionedSnapshot(snapshotSuperView: view) else {
            print("Snapshot Failed")
            return
        }
        coverImage.layer.cornerRadius = 5.0
        //coverImage.clipsToBounds = true
        
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
            coverImage.transform = coverImage.transform.scaledBy(x: 1.05, y: 1)
            coverImage.layer.zPosition = 1.0
            coverImage.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            coverImage.layer.shadowRadius = 5.0
            coverImage.layer.shadowOpacity = 0.25
            coverImage.layer.shadowColor = UIColor.black.cgColor
            
        })
        CATransaction.commit()
    }
    
}

extension UIView {
    
    func positionedSnapshot(snapshotSuperView:UIView, afterScreenUpdates:Bool = false) -> UIView? {
        guard let parent = superview else {
            return nil
        }
        guard let coverImage = resizableSnapshotView(from: bounds, afterScreenUpdates: afterScreenUpdates, withCapInsets: .zero) else {
            print("Snapshot Failed")
            return nil
        }
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        snapshotSuperView.addSubview(coverImage)
        coverImage.frame = parent.convert(frame, to: snapshotSuperView)
        return coverImage
        
    }
    
}

