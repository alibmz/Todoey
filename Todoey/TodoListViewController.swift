//
//  ViewController.swift
//  Todoey
//
//  Created by Ali Bazzaz on 19/05/2018.
//  Copyright © 2018 ABMZ. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    // MARK :- one pipe element
    var itemArray = [Item] ()
    var selectedCategory : Category? {
        didSet{
            loadItems ()
        }
    }
    // MARK :- Save all application in the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // MARK: - Reload Data
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK :- to be deleted
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      
    }
//MARK - Tableview Datasource Methods
    // to create a list with the data above, cell counter and cell filler linked to the data array (source above) with indexpath.row using tableview dequeu
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // row filler
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
        
    }
    
    // MARK - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at:indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
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
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory

           self.itemArray.append (newItem)
            
            self.saveItems()
            
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
    // MARK: - Save all data (pipes) in the context, funtion to be used remotely
    func saveItems () {
        
        do {
           try context.save()
        } catch {
            print ("Error saving context \(error)")
        }
        
        self.tableView.reloadData ()
        
        
    }
    // MARK:- getting all pipes in one category in the table view
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        
        let categoryPredicate = NSPredicate (format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch (request)
        } catch {
            print ("Error fetching data from context \(error)")
        }
        tableView.reloadData ()
        
        
        }
   
    
    }

//MARK: - Search bar methods (fetching data from search bar)

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
    let predicate = NSPredicate(format:"title CONTAINS [cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key:"title", ascending:true)]
        loadItems (with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems ()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder ()
            }
                }
    }
        
    
}



