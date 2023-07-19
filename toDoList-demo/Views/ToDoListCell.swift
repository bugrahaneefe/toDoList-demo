//
//  ToDoListCell.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 18.07.2023.
//

import UIKit
import Firebase

protocol ToDoListCellDelegate: AnyObject {
    func textFieldDidChange(text: String, in cell: ToDoListCell)
    func statusButtonTapped(in cell: ToDoListCell)
}

class ToDoListCell: UITableViewCell {
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var toDoListTextArea: UITextField!
    
    let db = Firestore.firestore()
    
    weak var delegate: ToDoListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        toDoListTextArea.layer.cornerRadius = 15.0
        toDoListTextArea.layer.borderWidth = 1.0
        
        toDoListTextArea.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldDidChange(text: textField.text ?? "", in: self)
    }

    @IBAction func statusButtonPressed(_ sender: UIButton) {
        delegate?.statusButtonTapped(in: self)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}



