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
    
    let defaults = UserDefaults.standard
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //downcast singleton to AppDelegate to allow us to access the container
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        loadItems()
        
        // TODO: Remove this, it's just for debugging purposes.
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
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
        
        saveItem() // updates the storage .plist with newly toggled status
        
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
            
            // creates new "item" item in the database
            // TODO: implement error checking - nil, etc
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.isDone = false
            self.itemArray.append(newItem)
            
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
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("!!! ERROR - Unable to fetch data from context: \(error)")
        }
    }
    

}

