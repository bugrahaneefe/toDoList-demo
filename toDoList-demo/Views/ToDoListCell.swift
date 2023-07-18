//
//  ToDoListCell.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 18.07.2023.
//

import UIKit

class ToDoListCell: UITableViewCell {

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var toDoListTextArea: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        toDoListTextArea.layer.cornerRadius = 15.0
        toDoListTextArea.layer.borderWidth = 1.0
        
    }
    
    
    @IBAction func statusButtonPressed(_ sender: UIButton) {
        if statusButton.image(for: .normal) == UIImage(systemName: "circle")! {
            statusButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }else{
            statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
