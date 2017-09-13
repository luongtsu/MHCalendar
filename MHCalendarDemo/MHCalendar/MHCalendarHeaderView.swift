//
//  MHCalendarHeaderView.swift
//  MHCalendarDemo
//
//  Created by Luong Minh Hiep on 9/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol MHCalendarHeaderViewResponsible: class {
    
    func moveToAnotherMonth(isNextMonth: Bool)
}

class MHCalendarHeaderView: UINibView {
    
    static let defaultHeight: CGFloat = 70
    
    @IBOutlet weak var weekdayLabel1: UILabel!
    @IBOutlet weak var weekdayLabel2: UILabel!
    @IBOutlet weak var weekdayLabel3: UILabel!
    @IBOutlet weak var weekdayLabel4: UILabel!
    @IBOutlet weak var weekdayLabel5: UILabel!
    @IBOutlet weak var weekdayLabel6: UILabel!
    @IBOutlet weak var weekdayLabel7: UILabel!
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    weak var observer: MHCalendarHeaderViewResponsible?
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        observer?.moveToAnotherMonth(isNextMonth: false)
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        observer?.moveToAnotherMonth(isNextMonth: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let calendar = Calendar.current
        let weeksDayList = calendar.shortWeekdaySymbols
        
        if Calendar.current.firstWeekday == 2 {
            weekdayLabel1.text = weeksDayList[1]
            weekdayLabel2.text = weeksDayList[2]
            weekdayLabel3.text = weeksDayList[3]
            weekdayLabel4.text = weeksDayList[4]
            weekdayLabel5.text = weeksDayList[5]
            weekdayLabel6.text = weeksDayList[6]
            weekdayLabel7.text = weeksDayList[0]
        } else {
            weekdayLabel1.text = weeksDayList[0]
            weekdayLabel2.text = weeksDayList[1]
            weekdayLabel3.text = weeksDayList[2]
            weekdayLabel4.text = weeksDayList[3]
            weekdayLabel5.text = weeksDayList[4]
            weekdayLabel6.text = weeksDayList[5]
            weekdayLabel7.text = weeksDayList[6]
        }
    }
    
    func updateWeekendLabelColor(_ color: UIColor)
    {
        if Calendar.current.firstWeekday == 2 {
            weekdayLabel6.textColor = color
            weekdayLabel7.textColor = color
        } else {
            weekdayLabel1.textColor = color
            weekdayLabel7.textColor = color
        }
    }
    
    func updateWeekdaysLabelColor(_ color: UIColor) {
        if Calendar.current.firstWeekday == 2 {
            weekdayLabel1.textColor = color
            weekdayLabel2.textColor = color
            weekdayLabel3.textColor = color
            weekdayLabel4.textColor = color
            weekdayLabel5.textColor = color
        } else {
            weekdayLabel2.textColor = color
            weekdayLabel3.textColor = color
            weekdayLabel4.textColor = color
            weekdayLabel5.textColor = color
            weekdayLabel6.textColor = color
        }
    }
}
