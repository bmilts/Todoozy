//
//  ViewController.swift
//  Todoozy
//
//  Created by Brendan Milton on 04/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    // Array of class Item objects
    var itemArray = [Item]()
    
    // Core data
    // Get data
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Retrieve saved/persistent data if it exists
        loadItems()
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Termary operator ==>
        // value = condition ? valueIfTrue : valueIfFales
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        // Ternary conversion of above
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggling
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        // Flashes grey and back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add new items section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        // Alert button and textfield
        let alert = UIAlertController(title: "Add New Todoozy", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            // What happens once user clicks add item button
            print("Add item pressed!")
            
            let newItem = Item()
            newItem.title  = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
           
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
       
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems(){
    
        // Set itemArray to defaults
        let encoder = PropertyListEncoder()
    
        do {
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
        } catch {
        print("Error encoding item array, \(error)")
        }
    
        self.tableView.reloadData()
    
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
        }
    }

}

