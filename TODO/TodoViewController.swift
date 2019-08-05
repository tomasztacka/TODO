//
//  ViewController.swift
//  TODO
//
//  Created by TT8 on 04/08/2019.
//  Copyright © 2019 TT8. All rights reserved.
//

import UIKit
import SwipeCellKit

class TodoViewController: UITableViewController {
    
    var ittemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataFilePath)
        loadItems()
        tableView.rowHeight = 88.0
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.ittemArray.append(newItem)
            self.saveItems()
        }
        
        self.tableView.reloadData()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Your new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Model
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(ittemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding ittem array: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                ittemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    // MARK TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ittemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
        let item = ittemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.delegate = self
        
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ittemArray[indexPath.row].done = !ittemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    // MARK Swipe Cell Kit Delegate Methods

extension TodoViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            // handle action by updating model with deletion
            print("Edit")
            
            //var textField = UITextField()
            let item = self.ittemArray[indexPath.row].title
            
            var textField = UITextField()
            let alert = UIAlertController(title: "\(item)", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Change Item", style: .default) { (action) in
                let editItem = Item()
                editItem.title = textField.text!
                self.ittemArray[indexPath.row].title = editItem.title
                self.saveItems()
            }
            self.tableView.reloadData()
            
            alert.addTextField { (alertTextField) in
                alertTextField.text = item
                textField = alertTextField
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
              
        }
        
        // customize the action appearance
        editAction.image = UIImage(named: "Disclosure")
        
        return [editAction]
    }
}
