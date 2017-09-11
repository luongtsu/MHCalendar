//
//  MHCalendar.swift
//  MHCalendarDemo
//
//  Created by Luong Minh Hiep on 9/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//
/*
import UIKit

private let collectionCellReuseIdentifier = "MHCollectionViewCell"

protocol MHCalendarResponsible: class {
    
    func didSelectDate(date: Date)
    func didSelectDates(dates: [Date])
    func didSelectAnotherMonth(isNextMonth: Bool)
}

open class MHCalendar0: UIView {
    
    weak var mhCalendarObserver : MHCalendarResponsible?
    
    // Appearance
    var tintColor: UIColor
    var dayDisabledTintColor: UIColor
    var weekdayTintColor: UIColor
    var weekendTintColor: UIColor
    var todayTintColor: UIColor
    var dateSelectionColor: UIColor
    var monthTitleColor: UIColor
    
    var backgroundImage: UIImage?
    var backgroundColor: UIColor?
    
    // Other config
    var selectedDates = [Date]()
    var startDate: Date?
    var hightlightsToday: Bool = true
    var hideDaysFromOtherMonth: Bool = false
    var multiSelectEnabled: Bool = true
    
    var displayingMonthIndex: Int = 0// count from starting date
    fileprivate(set) open var startYear: Int
    fileprivate(set) open var endYear: Int
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // setup collectionview
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "MHCollectionViewCell", bundle: Bundle(for: MHCalendar.self )), forCellWithReuseIdentifier: collectionCellReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "MHCalendarHeaderView", bundle: Bundle(for: MHCalendar.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MHCalendarHeaderView")
        
        if backgroundImage != nil {
            self.collectionView!.backgroundView =  UIImageView(image: backgroundImage)
        } else if backgroundColor != nil {
            self.collectionView?.backgroundColor = backgroundColor
        } else {
            self.collectionView?.backgroundColor = UIColor.white
        }
    }
    
    public init(startYear: Int = Date().year(), endYear: Int = Date().year(), multiSelection: Bool = true, selectedDates: [Date] = []) {
        
        self.startYear = startYear
        self.endYear = endYear
        self.multiSelectEnabled = multiSelection
        self.selectedDates = selectedDates
        
        //Text color initializations
        self.tintColor = UIColor.rgb(192, 55, 44)
        self.dayDisabledTintColor = UIColor.rgb(200, 200, 200)
        self.weekdayTintColor = UIColor.rgb(46, 204, 113)
        self.weekendTintColor = UIColor.rgb(192, 57, 43)
        self.dateSelectionColor = UIColor.rgb(52, 152, 219)
        self.monthTitleColor = UIColor.rgb(211, 84, 0)
        self.todayTintColor = UIColor.rgb(248, 160, 46)
        
        //Layout creation
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: MHCalendarHeaderView.defaultHeight)
        super.init(collectionViewLayout: layout)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewFlowLayout

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let startDate = Date(year: startYear, month: 1, day: 1)
        let firstDayOfMonth = startDate.dateByAddingMonths(displayingMonthIndex)
        let addingPrefixDaysWithMonthDyas = ( firstDayOfMonth.numberOfDaysInMonth() + firstDayOfMonth.weekday() - Calendar.current.firstWeekday )
        let addingSuffixDays = addingPrefixDaysWithMonthDyas%7
        var totalNumber  = addingPrefixDaysWithMonthDyas
        if addingSuffixDays != 0 {
            totalNumber = totalNumber + (7 - addingSuffixDays)
        }
        
        return totalNumber
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseIdentifier, for: indexPath) as! MHCollectionViewCell
        
        let calendarStartDate = Date(year:startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths(displayingMonthIndex)
        let prefixDays = ( firstDayOfThisMonth.weekday() - Calendar.current.firstWeekday)
        
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
        }
        else {
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        let rect = UIScreen.main.bounds
        let screenWidth = rect.size.width - 7
        return CGSize(width: screenWidth/7, height: screenWidth/7);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 0, 5, 0); //top,left,bottom,right
    }
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MHCalendarHeaderView", for: indexPath) as! MHCalendarHeaderView
            
            let startDate = Date(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate.dateByAddingMonths(indexPath.section)
            
            header.currentMonthLabel.text = firstDayOfMonth.monthNameFull()
            header.currentMonthLabel.textColor = monthTitleColor
            header.updateWeekdaysLabelColor(weekdayTintColor)
            header.updateWeekendLabelColor(weekendTintColor)
            header.backgroundColor = UIColor.clear
            
            return header;
        }
        
        return UICollectionReusableView()
    }
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
}*/
