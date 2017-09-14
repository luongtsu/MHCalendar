//
//  ViewController.swift
//  MHCalendarDemo
//
//  Created by Luong Minh Hiep on 9/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calendarView: MHCalendar!

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomSwitch: UISwitch!
    @IBOutlet weak var topSwitch: UISwitch!
    
    @IBAction func topSwitchToggled(_ sender: Any) {
        calendarView.selectEnabled = !calendarView.selectEnabled
        calendarView.selectedDates.removeAll()
        calendarView.displayingDate = Date()
        calendarView.collectionView.reloadData()
    }
    
    @IBAction func bottomSwitchToggled(_ sender: Any) {
        calendarView.multiSelectEnabled = !calendarView.multiSelectEnabled
        calendarView.selectedDates.removeAll()
        calendarView.displayingDate = Date()
        calendarView.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.mhCalendarObserver = self
        calendarView.displayingDate = Date()
    }
}

extension ViewController: MHCalendarResponsible {
    
    func didSelectDate(date: Date) {
        infoLabel.text = "Info: Selected date: \(date) \n\(date.monthYearInfo())"
    }
    
    func didSelectDates(dates: [Date]) {
        infoLabel.text = "Info: Selected date: \(dates))"
    }
    
    func didSelectAnotherMonth(isNextMonth: Bool){
        infoLabel.text = isNextMonth ? "Info: Select Next month" : "Info: Select Previous month"
    }
}

