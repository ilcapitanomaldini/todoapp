//
//  StatusView.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import UIKit

class StatusView: UIView {
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subMessageLabel: UILabel!
    
    let nibName = "StatusView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setup(image: UIImage, title: String, subMessage: String) {
        statusImageView.image = image
        titleLabel.text = title
        subMessageLabel.text = subMessage
    }
}
