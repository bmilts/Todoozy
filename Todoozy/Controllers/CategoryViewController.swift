//
//  CategoryViewController.swift
//  Todoozy
//
//  Created by Brendan Milton on 10/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Code smell try!
    let realm = try! Realm()
    
    // Any query in results form
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // ?? Nil coalessing operator
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
        // Set cells name
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // Clicked on category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // CRUD Delete
        // Order must go context.delete then UI itemArray.remove
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        // If more segues use an if statement to check segue identifier "goToItems" etc
        
        // Grab selected cell category
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    // CRUD - Create
    func save(category : Category){
        
        // Set itemArray to defaults
        // 4. Data save context to Database
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    // CRUD - Read
    // Internal external calls
    // Request externally "with"
    // Internally "request"
    // Default value = Item.fetchRequest
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Alert button and textfield
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // What happens once user clicks add item button
            print("Add category pressed!")
            
            // 3. Data model create new item (NSManagedObjects or rows of tables)
            let newCategory = Category()
            
            // 4. Fill NSManaged objects fields
            newCategory.name  = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
