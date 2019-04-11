//
//  ViewController.swift
//  Todoey
//
//  Created by Jared Talbert on 12/8/18.
//  Copyright © 2018 Jared Talbert. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: Remove this default starter item. Or replace with something better
        let newItem1 = Item()
        newItem1.title = "Find Mike"
//        newItem1.isDone = true
        itemArray.append(newItem1)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }

    // MARK - TableView Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.title
        
        cell.accessoryType = currentItem.isDone ? .checkmark : .none // sets accessory type based on true or false. replaces following lines of code
        
//        if currentItem.isDone {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].isDone.toggle()
        
        tableView.reloadData()
        
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
            
            // TODO: implement error checking - nil, etc
//            self.itemArray.append(textField.text!)
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // sets the UserDefaults to the current itemArray to be used on next launch
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData() // refreshes the tableView, duh
            
            print("Add Action - Success (\(textField.text!))")
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Something to do..."
            textField = alertTextField // extends scope from alertTF to textField
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil);
    }
    

}

