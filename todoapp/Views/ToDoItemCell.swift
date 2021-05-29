//
//  ToDoItemCell.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import UIKit
typealias ToggleAction = ((Int, Bool)->Void)
class ToDoItemCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ToDoItemCell"
    static let nib = UINib(nibName: ToDoItemCell.reuseIdentifier, bundle: nil)
    
    @IBOutlet weak var checkboxView: CheckBox!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func checkBoxToggled(sender: CheckBox) {
        toggleAction?(self.tag, self.checkboxView.isChecked)
    }
    
    var toggleAction: ToggleAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        checkboxView.isChecked = false
        self.checkboxView.isUserInteractionEnabled = true
        tag = 0
    }
    
    func setup(title: String?, date: Date, id: Int, checkStatus: Bool = false, allowCheck: Bool = true, toggleAction: ToggleAction? = nil) {
        self.titleLabel.text = title
        self.dateLabel.text = date.string()
        self.tag = id
        self.toggleAction = toggleAction
        self.checkboxView.isChecked = checkStatus
        self.checkboxView.isUserInteractionEnabled = allowCheck
    }
    
    func setEnabledAesthetic() {
        self.titleLabel.textColor = UIColor.black
        self.dateLabel.textColor = UIColor.darkGray
        self.backgroundColor = UIColor.white
    }
    
    func setDisabledAesthetic() {
        self.titleLabel.textColor = UIColor.darkGray
        self.dateLabel.textColor = UIColor.gray
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
}
