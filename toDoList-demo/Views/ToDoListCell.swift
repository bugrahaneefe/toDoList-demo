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
    func minusButtonTapped(in cell: ToDoListCell)

}

class ToDoListCell: UITableViewCell {
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var toDoListTextArea: UITextField!
    @IBOutlet weak var minusButton: UIButton!
    
    weak var delegate: ToDoListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        toDoListTextArea.layer.cornerRadius = 15.0
        toDoListTextArea.layer.borderWidth = 1.0
        
        toDoListTextArea.delegate = self
   

    }


    @IBAction func statusButtonPressed(_ sender: UIButton) {
        delegate?.statusButtonTapped(in: self)
    }

    
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        delegate?.minusButtonTapped(in: self)
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

extension ToDoListCell: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldDidChange(text: textField.text ?? "", in: self)
//        print("\(textField.text)")
        return true
    }
    
}

