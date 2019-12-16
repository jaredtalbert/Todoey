//
//  ViewController.swift
//  Todoey
//
//  Created by Jared Talbert on 12/8/18.
//  Copyright © 2018 Jared Talbert. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK - TableView Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let currentItem = todoItems?[indexPath.row] {
            cell.textLabel?.text = currentItem.title
            
            cell.accessoryType = currentItem.isDone ? .checkmark : .none // sets accessory type based on true or false. replaces following lines of code
        } else {
            cell.textLabel?.text = "No Items Added Yet!"
        }
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        todoItems?[indexPath.row].isDone.toggle()
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("ERROR - Unable to save 'done' status of item, \(error)")
            }
        }
    
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.currentDate = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
        
            self.tableView.reloadData()
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
//    func saveItem() {
//        do {
//            try self.context.save()
//        } catch {
//            print("!!! ERROR - Unable to save context: \(error)")
//        }
//
//        self.tableView.reloadData() // refreshes the tableView, duh
//    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

// MARK: Search Bar Functionality
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "currentDate", ascending: true)
        
        tableView.reloadData()
        print("DEBUG - searched successfully?")
        
    }
        
        

    // if the user clears the search bar, show all items
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // deselect the search bar, also closes keyboard
            }

        }
    }
}
