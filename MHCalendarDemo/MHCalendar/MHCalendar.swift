//
//  MHCalendar.swift
//  MHCalendarDemo
//
//  Created by Luong Minh Hiep on 9/12/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol MHCalendarResponsible: class {
    
    func didSelectDate(date: Date)
    func didSelectDates(dates: [Date])
    func didSelectAnotherMonth(isNextMonth: Bool)
}


class MHCalendar: UINibView {
    
    @IBOutlet weak var headerView: MHCalendarHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var mhCalendarObserver : MHCalendarResponsible? = nil {
        didSet {
            didSetObserver()
        }
    }
    
    // Appearance
    var dayDisabledTintColor: UIColor!
    var weekdayTintColor: UIColor!
    var weekendTintColor: UIColor!
    var todayTintColor: UIColor!
    var dateSelectionColor: UIColor!
    var monthTitleColor: UIColor!
    
    // Other config
    var selectedDates = [Date]()
    var startDate: Date! = Date(year: 2017, month: 1, day: 1)
    var endDate: Date! = Date(year: 2057, month: 1, day: 1)
    var displayingDate: Date! = Date() {
        didSet {
            displayingYear = displayingDate.year()
            displayingMonth = displayingDate.month()
            firstDayOfThisMonth = Date(year: displayingYear, month: displayingMonth, day: 1)
        }
    }
    
    var hightlightsToday: Bool = true
    var hideDaysFromOtherMonth: Bool = false
    var multiSelectEnabled: Bool = true
    
    // Helper params
    fileprivate var displayingYear: Int = 2000
    fileprivate var displayingMonth: Int = 1
    fileprivate var firstDayOfThisMonth: Date! = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MHCollectionViewCell.register(to: self.collectionView)
    }
    
    private func didSetObserver() {
        headerView.observer = self
    }
    
    func config(startDate: Date = Date(), endDate: Date = Date(), displayingDate: Date = Date(), multiSelection: Bool = true, selectedDates: [Date] = []) {
        self.startDate = startDate
        self.endDate = endDate
        self.displayingDate = displayingDate
        
        self.multiSelectEnabled = multiSelection
        self.selectedDates = selectedDates
        
        //Text color initializations
        self.dayDisabledTintColor = UIColor.gray
        self.weekdayTintColor = UIColor.blue
        self.weekendTintColor = UIColor.red
        self.dateSelectionColor = UIColor.brown
        self.monthTitleColor = UIColor.rgb(211, 84, 0)
        self.todayTintColor = UIColor.green
        
        MHCollectionViewCell.register(to: self.collectionView)
        self.collectionView.backgroundColor = UIColor.clear
    }
}

extension MHCalendar: MHCalendarHeaderViewResponsible {
    
    func moveToAnotherMonth(isNextMonth: Bool) {
        mhCalendarObserver?.didSelectAnotherMonth(isNextMonth: isNextMonth)
    }
}

extension MHCalendar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let rect = UIScreen.main.bounds
        let screenWidth = rect.size.width - 7
        return CGSize(width: screenWidth/7, height: screenWidth/7)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MHCalendar: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDayOfThisMonth = Date(year: displayingYear, month: displayingMonth, day: 1)
        let addingPrefixDaysWithMonth = firstDayOfThisMonth.numberOfDaysInMonth() + firstDayOfThisMonth.weekday() - Calendar.current.firstWeekday
        let addingSuffixDays = addingPrefixDaysWithMonth % 7
        var totalNumber  = addingPrefixDaysWithMonth
        if addingSuffixDays != 0 {
            totalNumber = totalNumber + (7 - addingSuffixDays)
        }
        return totalNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = MHCollectionViewCell.dequeue(from: collectionView, indexPath: indexPath) else {
            assertionFailure("Need config MHCollectionViewCell")
            return UICollectionViewCell()
        }
        
        let prefixDays = firstDayOfThisMonth.weekday() - Calendar.current.firstWeekday
        
        if indexPath.row >= prefixDays {
            cell.isCellSelectable = true
            
            let currentDate = firstDayOfThisMonth.dateByAddingDays(indexPath.row-prefixDays)
            let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth()-1)
            
            cell.currentDate = currentDate
            cell.titleLabel.text = "\(currentDate.day())"
            
            if selectedDates.filter({ $0.isDateSameDay(currentDate)}).count > 0 && (firstDayOfThisMonth.month() == currentDate.month()) {
                cell.selectedForLabelColor(dateSelectionColor)
            } else {
                cell.deSelectedForLabelColor(weekdayTintColor)
                if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
                    cell.titleLabel.textColor = weekendTintColor
                }
                if (currentDate > nextMonthFirstDay) {
                    cell.isCellSelectable = false
                    if hideDaysFromOtherMonth {
                        cell.titleLabel.textColor = UIColor.clear
                    } else {
                        cell.titleLabel.textColor = self.dayDisabledTintColor
                    }
                }
                if currentDate.isToday() && hightlightsToday {
                    cell.setTodayCellColor(todayTintColor)
                }
                
                if startDate != nil {
                    if Calendar.current.startOfDay(for: cell.currentDate as Date) < Calendar.current.startOfDay(for: startDate!) {
                        cell.isCellSelectable = false
                        cell.titleLabel.textColor = self.dayDisabledTintColor
                    }
                }
            }
        } else {
            cell.deSelectedForLabelColor(weekdayTintColor)
            cell.isCellSelectable = false
            let previousDay = firstDayOfThisMonth.dateByAddingDays(-( prefixDays - indexPath.row))
            cell.currentDate = previousDay
            cell.titleLabel.text = "\(previousDay.day())"
            if hideDaysFromOtherMonth {
                cell.titleLabel.textColor = UIColor.clear
            } else {
                cell.titleLabel.textColor = self.dayDisabledTintColor
            }
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MHCollectionViewCell
        if !multiSelectEnabled && cell.isCellSelectable! {
            mhCalendarObserver?.didSelectDate(date: cell.currentDate)
            cell.selectedForLabelColor(dateSelectionColor)
            selectedDates.append(cell.currentDate)
            return
        }
        
        if cell.isCellSelectable! {
            if selectedDates.filter({ $0.isDateSameDay(cell.currentDate)
            }).count == 0 {
                selectedDates.append(cell.currentDate)
                cell.selectedForLabelColor(dateSelectionColor)
                
                if cell.currentDate.isToday() {
                    cell.setTodayCellColor(dateSelectionColor)
                }
            }
            else {
                selectedDates = selectedDates.filter(){
                    return  !($0.isDateSameDay(cell.currentDate))
                }
                if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
                    cell.deSelectedForLabelColor(weekendTintColor)
                }
                else {
                    cell.deSelectedForLabelColor(weekdayTintColor)
                }
                if cell.currentDate.isToday() && hightlightsToday{
                    cell.setTodayCellColor(todayTintColor)
                }
            }
        }
    }
}
