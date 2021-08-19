//
//  PersonTableViewCell.swift
//  ScorpCaseStudy
//
//  Created by ismailyildirim on 19.08.2021.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPerson: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(person: Person){
        self.labelPerson.text = "\(person.fullName) (\(person.id))"
    }
    
}
