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
    @IBOutlet weak var welcomeLabel: UILabel!
    let dtb = Firestore.firestore()
    var toDoList: [Todolist] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        showDisplayName()
        navigationItemEdit()
        tableViewEdit()
        loadTasksFromFirestore()
    }
    @IBAction func addButton(_ sender: UIButton) {
        toDoList.append(Todolist(sender: (Auth.auth().currentUser?.email)!,
                                 textField: NSLocalizedString("Enter a task", comment: ""),
                                 doneStatus: false))
        tableView.reloadData()
    }
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            self.showAlert(NSLocalizedString("Error signing out: ", comment: "")+"\(signOutError)")
        }
    }
    func navigationItemEdit() {
        navigationItem.hidesBackButton = true
        title = "To Do List"
    }
    func tableViewEdit() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellClassName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    /// Shows user's name at welcome label
    func showDisplayName() {
        if let currentUserDisplayName = Auth.auth().currentUser?.displayName {
            welcomeLabel.text =  NSLocalizedString("Welcome! \n"+"\(currentUserDisplayName)", comment: "")

        } else {
            welcomeLabel.text = NSLocalizedString("Welcome!", comment: "")
        }
    }
    /// Load task infos from database and updates UI
    func loadTasksFromFirestore() {
        toDoList = []
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        dtb.collection(K.collectionName)
            .whereField(K.sender, isEqualTo: currentUserEmail).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(NSLocalizedString("Error getting documents:", comment: "")+"\(error)")
            } else {
                if let queryDocuments = querySnapshot?.documents {
                    for doc in queryDocuments {
                        let data = doc.data()
                        if let senderData = data[K.sender] as? String,
                           let textData = data[K.textField] as? String,
                           let statusData = data[K.doneStatus] as? Bool {
                            self.toDoList.append(Todolist(sender: senderData,
                                                          textField: textData,
                                                          doneStatus: statusData))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at:
                                                            IndexPath(row: self.toDoList.count-1, section: 0)
                                                           , at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    /// Updates information of tasks in database
    /// - Parameter task: Todolist
    func updateTaskInFirestore(_ task: Todolist) {
        dtb.collection(K.collectionName).document("\(task.textField)_\(task.sender)").setData([
            K.sender: task.sender,
            K.textField: task.textField,
            K.doneStatus: task.doneStatus
        ]) { error in
            if let error = error {
                self.showAlert(NSLocalizedString("Error updating task in Firestore: ", comment: "")+"\(error)")
            } else {
                self.showAlert(NSLocalizedString("Task updated successfully in Firestore", comment: ""))
            }
        }
        tableView.reloadData()
    }
    /// Deletes information of tasks from database
    /// - Parameter task: Todolist
    func deleteFromFirestore(_ task: Todolist) {
        dtb.collection(K.collectionName).document("\(task.textField)_\(task.sender)").delete { error in
            if let error = error {
                self.showAlert(NSLocalizedString("Error deleting task from Firestore:", comment: "")+"\(error)")
            } else {
                self.showAlert(NSLocalizedString("Task deleted successfully from Firestore", comment: ""))
                if let index = self.toDoList
                    .firstIndex(where: { $0.textField == task.textField && $0.sender == task.sender }) {
                    self.toDoList.remove(at: index)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ToDoTaskController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? ToDoListCell {
            cell.delegate = self
            cell.toDoListTextArea.text = toDoList[indexPath.row].textField
            if toDoList[indexPath.row].doneStatus == false {
                cell.statusButton.setImage(UIImage(systemName: K.circle), for: .normal)
            } else {
                cell.statusButton.setImage(UIImage(systemName: K.circlefill), for: .normal)
            }
            return cell
        }
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
        return defaultCell
    }
}

extension ToDoTaskController: ToDoListCellDelegate {
    func textFieldDidChange(text: String, in cell: ToDoListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        toDoList[indexPath.row].textField = text
        updateTaskInFirestore(toDoList[indexPath.row])
    }
    func statusButtonTapped(in cell: ToDoListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        toDoList[indexPath.row].doneStatus.toggle()
        updateTaskInFirestore(toDoList[indexPath.row])
    }
    func minusButtonTapped(in cell: ToDoListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        deleteFromFirestore(toDoList[indexPath.row])
    }
}

extension ToDoTaskController {
    /// Alert message
    /// - Parameter message: String
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
