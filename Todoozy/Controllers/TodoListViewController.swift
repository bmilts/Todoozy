//
//  ViewController.swift
//  Todoozy
//
//  Created by Brendan Milton on 04/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    // Array of class Item objects
    var itemArray = [Item]()
    
    // Core data
    
    // 2. Data model access context
    // Tappng into UIApplication then classing into app delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get data location
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        // Retrieve saved/persistent data if it exists
        loadItems()
    }
    
    //MARK - TableView Datasource Methods
    
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
        
        // CRUD Delete
        // Order must go context.delete then UI itemArray.remove
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // Toggling Checked/Unchecked
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        // Flashes grey and back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        // Alert button and textfield
        let alert = UIAlertController(title: "Add New Todoozy", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            // What happens once user clicks add item button
            print("Add item pressed!")
            
            // 3. Data model create new item (NSManagedObjects or rows of tables)
            let newItem = Item(context: self.context)
            
            // 4. Fill NSManaged objects fields
            newItem.title  = textField.text!
            newItem.done = false
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
    
    //MARK: - Model Manipulation Methods
    
    // CRUD - Create
    func saveItems(){
    
        // Set itemArray to defaults
        // 4. Data save context to Database
        do {
            try context.save()
        } catch {
            print("Erro saving context \(error)")
        }
    
        self.tableView.reloadData()
    
    }
    
    // CRUD - Read
    // Internal external calls
    // Request externally "with"
    // Internally "request"
    // Default value = Item.fetchRequest
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do {
            // Speak to context first if successful save results in itemArray
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching  data from context \(error)")
        }
        
        tableView.reloadData()
    }

}


//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    // Triggered on search bar click
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request :  NSFetchRequest<Item> = Item.fetchRequest()
        
        // Filter query using core data by title
        // NSPredicate is a query language
        // [cd] Case and diacriticinsensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Sort data
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    // Check fot text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // When text goes back to 0 (Cross button or otherwise)
        if searchBar.text?.count == 0 {
            
            // Load items from database
            loadItems()
            
            // Manages execution of processing tasks
            // Main thread update user information
            DispatchQueue.main.async {
                // No longer editing revert back to state
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
}

