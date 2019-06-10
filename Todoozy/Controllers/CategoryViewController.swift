//
//  CategoryViewController.swift
//  Todoozy
//
//  Created by Brendan Milton on 10/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    // Context to get information
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
        // Set cells name
        cell.textLabel?.text = categories[indexPath.row].name
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    // CRUD - Create
    func saveCategories(){
        
        // Set itemArray to defaults
        // 4. Data save context to Database
        
        do {
            try context.save()
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
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            // Speak to context first if successful save results in itemArray
            categories = try context.fetch(request)
        } catch {
            print("Error fetching  data from context \(error)")
        }
        
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
            let newCategory = Category(context: self.context)
            
            // 4. Fill NSManaged objects fields
            newCategory.name  = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
