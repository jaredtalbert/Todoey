//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jared Talbert on 4/24/19.
//  Copyright © 2019 Jared Talbert. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    
    // MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let currentItem = categoryArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.name
        
//        cell.accessoryType = currentItem.isDone ? .checkmark : .none // sets accessory type based on true or false. replaces following lines of code
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    // MARK: TableView Delegate Methods
    // save, load
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemArray[indexPath.row].isDone.toggle()
        
        
        // TODO: Make deleting items work better
        //        context.delete(itemArray[indexPath.row]) // submits changes to persistent storage context to be finalized
        //        itemArray.remove(at: indexPath.row) // removes from the array, for updating the TableView
        
        saveCategory() // finalizes context changes
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveCategory() {
        do {
            try self.context.save()
        } catch {
            print("!!! ERROR - Unable to save context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try categoryArray = self.context.fetch(request)
        } catch {
            print("!!! ERROR - Unable to fetch context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Category Name..."
            textField = categoryTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Data Manipulation Methods
    
}
