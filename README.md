# MHCalendar
Custom calendar for date selection or to highlight selected dates

*MHCalendar does require Xcode 8 and Swift 3.0*

Preview
-------
![Screenshot](https://github.com/luongtsu/MHCalendar/blob/master/Screenshots/Example.png)


Installation
------------

#### CocoaPods
Will be availabe soon
#### Manual Installation

Just drag and drop the `MHCalendar` folder into your project

Demo
----

Download and see the demo project [here](https://github.com/luongtsu/MHCalendar/tree/master/MHCalendarDemo)

Features
--------

MHCalendar provides lot of features which lets you customize the date picker

1. Single selection and multiselection option
2. You could disable section to switch to only preview mode
3. Color of date indicators are customizable
4. Show/hide date out of selected range
5. Last but not least: easy config and use

Initialization
--------------
You can easy drag and drop MHCalendar view via storyBoard, then config it in the viewController's viewDidLoad() function:

```swift
        calendarView.mhCalendarObserver = self // set update delegate
        calendarView.mhCalendarObserver = self
        calendarView.displayingDate = Date()
        calendarView.startDate = Date(year: 2000, month: 1, day: 1)
        calendarView.endDate = Date(year: 2100, month: 1, day: 1)
        calendarView.weekdayTintColor = UIColor.darkGray
        calendarView.weekendTintColor = UIColor.red
        calendarView.todayTintColor = UIColor.green
        calendarView.dateSelectionColor = UIColor.blue
```

Properties
----------

Name | Description
---- | ---------
**`weekdayTintColor`**|`Weekday title and date color`
**`weekendTintColor`**|`Weekend title and date color`
**`todayTintColor`**|`Today bar button the today's date color`
**`dateSelectionColor`**|`Selected date color`
**`dayDisabledTintColor`**|`Disabled day tint color`
**`multiSelectEnabled`**|`Boolean value indicating whether multiselection enabled or not`
**`startDate`**|`Starting date of the range`
**`endDate`**|`Ending date of the range`
**`displayingDate`**|`current displaying date on the calendar view`
**`hideDaysFromOtherMonth`**|`Hides the days of other months with empty spaces`
**`monthTitleColor`**|`Month title color`
**`monthBackgroundColor`**|`Background Color of the Month view`


Delegation
---------
MHCalendar define a protocol named **MHCalendarResponsible** to help viewController be informed about dateSelection change.
To do this, viewController should conform above protocol by making extension like following:  
      
```swift
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
```

License
-------
MHCalendar is available under the MIT license. See the [LICENSE](https://github.com/luongtsu/MHCalendar/blob/master/LICENSE) file for more info.
