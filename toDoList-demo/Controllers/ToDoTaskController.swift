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

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserDisplayName = Auth.auth().currentUser?.displayName {
            welcomeLabel.text = "Welcome! \n\(currentUserDisplayName)"
        }else{
            welcomeLabel.text = "Welcome!"
        }
        
        navigationItem.hidesBackButton = true
        title = "To Do List"
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellClassName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadTasksFromFirestore()
    }
    
    func loadTasksFromFirestore(){
        toDoList = []
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        
        db.collection(K.collectionName).whereField(K.sender, isEqualTo: currentUserEmail).getDocuments { querySnapshot, error in
            if let e = error {
                print("Error getting documents: \(e)")
            } else {
                if let queryDocuments = querySnapshot?.documents {
                    for doc in queryDocuments{
                        let data = doc.data()
                        if let senderData = data[K.sender] as? String,
                           let textData = data[K.textField] as? String,
                           let statusData = data[K.doneStatus] as? Bool{
                            
                            self.toDoList.append(todolist(sender: senderData, textField: textData, doneStatus: statusData))
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                self.tableView.scrollToRow(at: IndexPath(row: self.toDoList.count-1, section: 0), at: .top, animated: true)
                            }
                            
                        }
                        
                        
                    }
                }
            }
            
        }
    }
    
    func updateTaskInFirestore(_ task: todolist) {
        db.collection(K.collectionName).document("\(task.textField)_\(task.sender)").setData([
            K.sender: task.sender,
            K.textField: task.textField,
            K.doneStatus: task.doneStatus
        ]) { error in
            if let error = error {
                print("Error updating task in Firestore: \(error)")
            } else {
                print("Task updated successfully in Firestore")
            }
        }
        tableView.reloadData()


    }
    
    func deleteFromFirestore(_ task: todolist){
        
        
        db.collection(K.collectionName).document("\(task.textField)_\(task.sender)").delete { error in
            if let error = error {
                print("Error deleting task from Firestore: \(error)")
            } else {
                print("Task deleted successfully from Firestore")
                if let index = self.toDoList.firstIndex(where: { $0.textField == task.textField && $0.sender == task.sender }) {
                    self.toDoList.remove(at: index)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
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
    
}

extension ToDoTaskController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ToDoListCell
        
        cell.delegate = self
        
        cell.toDoListTextArea.text = toDoList[indexPath.row].textField
        
        
        if toDoList[indexPath.row].doneStatus == false{
            cell.statusButton.setImage(UIImage(systemName: K.circle), for: .normal)
            
        }else{
            cell.statusButton.setImage(UIImage(systemName: K.circlefill), for: .normal)
            
        }
        
        
        
        return cell
    }
    
}

extension ToDoTaskController: ToDoListCellDelegate{
    
    
    func textFieldDidChange(text: String, in cell: ToDoListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        toDoList[indexPath.row].textField = text
        
        updateTaskInFirestore(toDoList[indexPath.row])
        print("Text Field Changed")
        
    }
    
    func statusButtonTapped(in cell: ToDoListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        toDoList[indexPath.row].doneStatus.toggle()

        updateTaskInFirestore(toDoList[indexPath.row])
        print("Status Button Changed")
        
    }
    
    
    func minusButtonTapped(in cell: ToDoListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        deleteFromFirestore(toDoList[indexPath.row])
        print("Minus Button Pressed")
        
    }
    
}


