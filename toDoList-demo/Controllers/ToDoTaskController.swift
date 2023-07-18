//
//  ToDoTaskController.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 17.07.2023.
//

import UIKit
import Firebase

class ToDoTaskController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!

    let db = Firestore.firestore()
    
    var toDoList: [todolist] = []
    
//    todolist(sender: (Auth.auth().currentUser?.email)!, textField: "Get a milk", doneStatus: true),todolist(sender: (Auth.auth().currentUser?.email)!, textField: "Get a milk", doneStatus: false),todolist(sender: (Auth.auth().currentUser?.email)!, textField: "Get a milk", doneStatus: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        title = "To Do List"
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoListCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

        
    }
    
    func loadTasks(){
        
    }
    
    func sendTasks(){
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        toDoList.append(todolist(sender: (Auth.auth().currentUser?.email)!, textField: "Enter a task", doneStatus: false))
        
        
        
        
        tableView.reloadData()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ToDoTaskController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ToDoListCell
        
        cell.toDoListTextArea.text = toDoList[indexPath.row].textField
        
        if toDoList[indexPath.row].doneStatus == false{
            cell.statusButton.setImage(UIImage(systemName: "circle"), for: .normal)

        }else{
            cell.statusButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            
        }
        
        return cell
    }
    
}


