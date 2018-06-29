//
//  ViewController.swift
//  HW4
//
//  Created by Sunggat Aiymbay on 28.06.2018.
//  Copyright © 2018 Sunggat Aiymbay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var toDoItems = [ToDoItem]()
    var filterToDoItems = [ToDoItem]()
    var categoryToDoItems = [ToDoItem]()
    var textField: UITextField?
    var srt: Int = 0
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    
    @IBOutlet weak var sortSegmented: UISegmentedControl!
    
    @IBAction func editButton(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
    }
    @IBAction func sortActionSegm(_ sender: Any) {

        switch sortSegmented.selectedSegmentIndex {
        case 0:
            categoryToDoItems = toDoItems
            tableView.reloadData()
        case 1:
            categoryToDoItems = toDoItems.filter({ToDoItem -> Bool in
            ToDoItem.completed == true})
            tableView.reloadData()
        case 2:
            categoryToDoItems = toDoItems.filter({ToDoItem -> Bool in
                ToDoItem.completed == false})
            tableView.reloadData()
        default:
            break
        }
        
    }
    
    func setupAlert() {
        let alert = UIAlertController( title: "Add", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            self.textField = textField
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            if let text = self.textField?.text {
                self.toDoItems.append(ToDoItem(name: text))
                self.filterToDoItems = self.toDoItems
                self.tableView.reloadData()
            }
            }))
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterToDoItems.count
        }
        else if sortSegmented.selectedSegmentIndex == 1 || sortSegmented.selectedSegmentIndex == 2  {
            return categoryToDoItems.count
        }
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearching {
            cell.textLabel?.text = filterToDoItems[indexPath.row].text
            cell.accessoryType = .none
        }
        else if sortSegmented.selectedSegmentIndex>0 {
            cell.textLabel?.text = categoryToDoItems[indexPath.row].text
            cell.accessoryType = .none
        }
        else {
            cell.textLabel?.text = toDoItems[indexPath.row].text
            cell.accessoryType = .none
        }
        return cell
        
    }
    
    
    
    // CheckMark
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                toDoItems[indexPath.row].completed = false
                
            }
            else{
                cell.accessoryType = .checkmark
                toDoItems[indexPath.row].completed = true
            }
        }
    }
    
    // MoveRow
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         let toDoItemsMove = self.toDoItems[sourceIndexPath.row]
         toDoItems.remove(at: sourceIndexPath.row)
         toDoItems.insert(toDoItemsMove, at: destinationIndexPath.row)
    }
    @IBAction func addButton(_ sender: Any) {
        setupAlert()
    }
    
    
    // Delete Row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            // self.toDoItems.remove(at: IndexPath)
            toDoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
           // tableView.reloadData()
            
        }
    }
    
    //SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else {
            isSearching = true
            filterToDoItems = toDoItems.filter({ToDoItem -> Bool in
                guard let text = searchBar.text else {return false}
                return ToDoItem.text.contains(text)
            })
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableView.isEditing
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

