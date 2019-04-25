//
//  ViewController.swift
//  Todoey
//
//  Created by Jared Talbert on 12/8/18.
//  Copyright © 2018 Jared Talbert. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
//            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //downcast singleton to AppDelegate to allow us to access the container
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK - TableView Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.title
        
        cell.accessoryType = currentItem.isDone ? .checkmark : .none // sets accessory type based on true or false. replaces following lines of code
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isDone.toggle()
        
        
        // TODO: Make deleting items work better
//        context.delete(itemArray[indexPath.row]) // submits changes to persistent storage context to be finalized
//        itemArray.remove(at: indexPath.row) // removes from the array, for updating the TableView
        
        saveItem() // finalizes context changes
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // extends the scope of the textfield used later so that information can be grabbed from it
        
        // sets up the actual alert box
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // adds action buttons to the alert box
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // implement what happens when the user presses the "Add Item" button
            
            // creates new "item" item in the database
            // TODO: implement error checking - nil, etc
//            let newItem = Item()
//            newItem.title = textField.text!
//            newItem.isDone = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
            // sets the UserDefaults to the current itemArray to be used on next launch
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItem()
            
            print("Add Action - Success (\(textField.text!))")
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Something to do..."
            textField = alertTextField // extends scope from alertTF to textField
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil);
    }
    
    // MARK: Saving/Loading Mechanism
    func saveItem() {
        do {
            try self.context.save()
        } catch {
            print("!!! ERROR - Unable to save context: \(error)")
        }
        
        self.tableView.reloadData() // refreshes the tableView, duh
    }
    
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
////        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
////
////
////        if let additionalPredicate = predicate {
////            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
////        } else {
////            request.predicate = categoryPredicate
////        }
////
////        do {
////            itemArray = try context.fetch(request)
////        } catch {
////            print("!!! ERROR - Unable to fetch data from context: \(error)")
////        }
////
////        tableView.reloadData()
//    }
}

// MARK: Search Bar Functionality
//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    // if the user clears the search bar, show all items
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder() // deselect the search bar, also closes keyboard
//            }
//
//        }
//    }
//}
