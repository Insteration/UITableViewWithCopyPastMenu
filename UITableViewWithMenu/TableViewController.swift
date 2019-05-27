//
//  TableViewController.swift
//  UITableViewWithMenu
//
//  Created by Артём Кармазь on 5/24/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private var names: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        names = [String]()
        for _ in 0...50 {
            names.append(randomString(length: Int.random(in: 3...14)))
        }
    }
    
    @IBAction func editTableViewButton(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    // MARK: Names generate
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            names.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = names[sourceIndexPath.row]
        names.remove(at: sourceIndexPath.row)
        names.insert(item, at: destinationIndexPath.row)
    }
    
}

extension TableViewController {
    
    // MARK: Table view Pasterboard
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)  -> Bool {
        
        switch action {
        case #selector(copy(_:)):
            print("copy")
            return true
        case #selector(paste(_:)):
            print("paste")
            return true
        default:
            ()
        }
        
        return false // if treu that added all items in menu by pasteboard
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        
        let pasteBoard = UIPasteboard.general
        
        if action == #selector(copy(_:)) {
            let cell = tableView.cellForRow(at: indexPath)
            pasteBoard.string = cell?.textLabel?.text
        } else if action == #selector(paste(_:)) {
            names[indexPath.row] = pasteBoard.string!
            tableView.reloadData()
        }
    }
}
