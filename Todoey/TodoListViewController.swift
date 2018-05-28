//
//  ViewController.swift
//  Todoey
//
//  Created by Ali Bazzaz on 19/05/2018.
//  Copyright © 2018 ABMZ. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
//MARK - Tableview Datasource Methods
    // to create a list with the data above, cell counter and cell filler linked to the data array (source above) with indexpath.row using tableview dequeu
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // row filler
        cell.textLabel?.text = itemArray [indexPath.row]
        return cell
        
    }
    
    // MARK - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray [indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //accessable text field from the alert
        var textField = UITextField()
        
        // create the alert
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // creat the Action link in the alert
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            // the text to the var text field
           self.itemArray.append (textField.text!)
            self.tableView.reloadData()
        }
        // what happen after pressing the alert
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        // what happend after pressing the add button
        alert.addAction (action)
        present (alert, animated:true, completion:nil)
    }
    
    
    }



