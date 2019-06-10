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
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        // Termary operator ==>
        // value = condition ? valueIfTrue : valueIfFales
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        // Ternary conversion of above
        // cell.accessoryType = ite.done ? .checkmark : .none
        
        return cell
    }
    
    // Clicked on category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // CRUD Delete
        // Order must go context.delete then UI itemArray.remove
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        // Toggling Checked/Unchecked
        // categoryArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // saveCategories()
        
        // Flashes grey and back to white
        // tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    
    // CRUD - Create
    func saveCategories(){
        
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
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            // Speak to context first if successful save results in itemArray
            categoryArray = try context.fetch(request)
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
        
        let action = UIAlertAction(title: "Add Category", style: .default) {(action) in
            
            // What happens once user clicks add item button
            print("Add category pressed!")
            
            // 3. Data model create new item (NSManagedObjects or rows of tables)
            let newCategory = Category(context: self.context)
            
            // 4. Fill NSManaged objects fields
            newCategory.name  = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods
    
    
}
