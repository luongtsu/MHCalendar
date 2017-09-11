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

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.mhCalendarObserver = self
        calendarView.config()
    }
}

extension ViewController: MHCalendarResponsible {
    
    func didSelectDate(date: Date) {
        print(date)
    }
    
    func didSelectDates(dates: [Date]) {
        print(dates)
    }
    
    func didSelectAnotherMonth(isNextMonth: Bool){
        print(isNextMonth)
    }
}

