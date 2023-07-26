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
                                 textField: "enter.task".locally(),
                                 doneStatus: false))
        tableView.reloadData()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            self.showAlert("err.signout".locally()+"\(signOutError)")
        }
    }
    
    func navigationItemEdit() {
        navigationItem.hidesBackButton = true
        title = "to.do.list".locally()
    }
    
    func tableViewEdit() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: Keys.cellClassName, bundle: nil), forCellReuseIdentifier: Keys.cellIdentifier)
    }
    
    /// Shows user's name at welcome label
    func showDisplayName() {
        if let currentUserDisplayName = Auth.auth().currentUser?.displayName {
            welcomeLabel.text = String(format: "welcome".locally(), currentUserDisplayName)

        } else {
            welcomeLabel.text = "welcome.".locally()
        }
    }
    
    /// Load task infos from database and updates UI
    func loadTasksFromFirestore() {
        toDoList = []
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        dtb.collection(Keys.collectionName)
            .whereField(Keys.sender, isEqualTo: currentUserEmail).getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(String(format: "err.get.doc".locally(),error))
            } else {
                if let queryDocuments = querySnapshot?.documents {
                    for doc in queryDocuments {
                        let data = doc.data()
                        if let senderData = data[Keys.sender] as? String,
                           let textData = data[Keys.textField] as? String,
                           let statusData = data[Keys.doneStatus] as? Bool {
                            self.toDoList.append(Todolist(sender: senderData,
                                                          textField: textData,
                                                          doneStatus: statusData))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at:
                                                            IndexPath(row:self.toDoList.count-1,
                                                                      section: 0),
                                                                        at: .top,
                                                                        animated: true)
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
        dtb.collection(Keys.collectionName).document("\(task.textField)_\(task.sender)").setData([
            Keys.sender: task.sender,
            Keys.textField: task.textField,
            Keys.doneStatus: task.doneStatus
        ]) { error in
            if let error = error {
                self.showAlert(String(format:"err.update.firestore".locally(),error))
            } else {
                self.showAlert("succ.update.firestore".locally())
            }
        }
        tableView.reloadData()
    }
    
    /// Deletes information of tasks from database
    /// - Parameter task: Todolist
    func deleteFromFirestore(_ task: Todolist) {
        dtb.collection(Keys.collectionName).document("\(task.textField)_\(task.sender)").delete { error in
            if let error = error {
                self.showAlert(String(format:"err.delete.firestore".locally(),error))
            } else {
                self.showAlert("succ.delete.firestore".locally())
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: Keys.cellIdentifier,
                                                    for: indexPath) as? ToDoListCell {
            cell.delegate = self
            cell.toDoListTextArea.text = toDoList[indexPath.row].textField
            if !toDoList[indexPath.row].doneStatus {
                cell.statusButton.setImage(UIImage(systemName: Keys.circle), for: .normal)
            } else {
                cell.statusButton.setImage(UIImage(systemName: Keys.circlefill), for: .normal)
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

extension UIViewController {
    
    /// Alert message
    /// - Parameter message: String
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok".locally(), style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension String {
    
    func locally() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}
