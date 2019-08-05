//
//  ViewController.swift
//  TODO
//
//  Created by TT8 on 04/08/2019.
//  Copyright © 2019 TT8. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var ittemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
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
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = ittemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
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

