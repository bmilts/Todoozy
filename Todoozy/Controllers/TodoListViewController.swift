//
//  ViewController.swift
//  Todoozy
//
//  Created by Brendan Milton on 04/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    // Array of class Item objects
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    // Optional Category didSet allows load items if required
    var selectedCategory : Category? {
        didSet {
            
            // Retrieve saved/persistent data if it exists
            loadItems()
        }
    }
    
    // Core data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get data location
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
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
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // CRUD Delete
        // Order must go context.delete then UI itemArray.remove
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // Toggling Checked/Unchecked
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
        // Flashes grey and back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        // Alert button and textfield
        let alert = UIAlertController(title: "Add New Todoozy", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            // Save new item to Realm database
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title  = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving category \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
       
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    
    // CRUD - Read
    // Internal external calls
    // Request externally "with"
    // Internally "request"
    // Default value = Item.fetchRequest
    // Predicate == search
    // Optional NSPrredicate
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}
//
//
////MARK: - Search bar methods
//extension TodoListViewController : UISearchBarDelegate {
//
//    // Triggered on search bar click
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request :  NSFetchRequest<Item> = Item.fetchRequest()
//
//        // Filter query using core data by title
//        // NSPredicate is a query language
//        // [cd] Case and diacriticinsensitive
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // Sort data
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    // Check fot text changes
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        // When text goes back to 0 (Cross button or otherwise)
//        if searchBar.text?.count == 0 {
//
//            // Load items from database
//            loadItems()
//
//            // Manages execution of processing tasks
//            // Main thread update user information
//            DispatchQueue.main.async {
//                // No longer editing revert back to state
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//    }
//
// }

