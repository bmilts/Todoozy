//
//  ViewController.swift
//  Todoozy
//
//  Created by Brendan Milton on 04/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    // Array of class Item objects
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        
        tableView.separatorStyle = .none
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
            
        updateNavBar(withHexCode: colorHex)
    }
    
    // Reset navbar attributes
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Navbar setup methods
    
    func updateNavBar(withHexCode colorHexCode : String){
        
        // Guard against if navbar is nill
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Only called if not null
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Can force unwrap due being contained in if let
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
//            print("version 1: \(CGFloat(indexPath.row / todoItems!.count))" )
//
//            print("version 1: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")

            
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
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                 item.done = !item.done
            }
            } catch {
                print("Error saving status, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
                        newItem.dateCreated = Date()
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
    
    override func updateModel(at indexPath: IndexPath) {
            
            if let item = self.todoItems?[indexPath.row]{
                
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                }catch {
                    print("Error deleting categoru, \(error)")
                }
                
            }
        }
}


//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {

    // Triggered on search bar click
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Query realm database
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

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

