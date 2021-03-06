//
//  ViewController.swift
//  Todoey App
//
//  Created by Rajagopal Srinivasan on 5/9/19.
//  Copyright © 2019 Rajagopal Srinivasan. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
 
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        
       loadItems()
        
        

      
    }
    
    
//MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.tittle
        
        cell.accessoryType = item.done  ? .checkmark : .none
        
        
        return cell
    }
    
        // Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item()
            newItem.tittle = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
            

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
             textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - Model Manipulation Methods
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
            
        catch{
            print("Error encoding item array\(error)")
            
        }
        
        
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
            
                let decoder = PropertyListDecoder()
            do{
        itemArray = try decoder.decode([Item].self, from: data)
                
            }
            
            catch{
                print("Error decoding item array\(error)")
            }
                
        }
        
    }
}


