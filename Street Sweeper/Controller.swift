//
//  Controller.swift
//  Street Sweeper
//
//  Created by Jason Kelly on 11/27/22.
//

import UIKit

class DateModel {
    
//    var parkDate: Date {
//        didSet(newValue) {
//            self.weekOfDate = calcNthWeekOfMonth(dayOfMonth: newValue)
//        }
//    }
    var timeFrameDict: [(Date, Int, String, String)]
    var parkDate: Date
    var returnDate: Date {
        didSet {
            self.weekOfDate = calcNthWeekOfMonth(dayOfMonth: returnDate)
            self.timeFrameDict = calcTimeFrame(startDate: parkDate, returnDate: returnDate)
        }
    }
    var weekOfDate: [Date: Int]
    
    init(parkDate: Date, returnDate: Date? = nil) {
        self.parkDate = parkDate
        if let returnD = returnDate {
            self.returnDate = returnD
            self.weekOfDate = calcNthWeekOfMonth(dayOfMonth: returnD)
            self.timeFrameDict = calcTimeFrame(startDate: self.parkDate, returnDate: returnD)
        } else {
            self.returnDate = Calendar.current.date(byAdding: .day, value: 7, to: parkDate)!
            self.weekOfDate = calcNthWeekOfMonth(dayOfMonth: self.returnDate)
            self.timeFrameDict = calcTimeFrame(startDate: self.parkDate, returnDate: self.returnDate)
        }
    }
    
}

func calcNthWeekOfMonth(dayOfMonth: Date) -> [Date: Int] {
    // calculate what nth week of the month
    // the entered date is
    // e.g. monday the 3rd is the -> "1st" Monday of the month
    
    // 1. get current year, month and day from the date
    // 2. get number of days in given month
    let calendar = Calendar(identifier: .gregorian)
    let components = dayOfMonth.get(.day, .month, .year)
    
    // get # days in given month
    let range = calendar.range(of: .day, in: .month, for: dayOfMonth)!
    let numDays = range.count
    
    var weekArr = [Date: Int]()
    // calculate
    if let day = components.day, let month = components.month, let year = components.year {
        print("day: \(day), month: \(month), year: \(year)")
        for thisDay in components.day! ... numDays {
            let date = calendar.date(
                from: DateComponents(
                    era: 1,
                    year: year,
                    month: month,
                    day: thisDay,
                    hour: 12,
                    minute: 0,
                    second: 0
                )
            )!
//            print(day, calendar.component(.weekOfMonth, from: date))
            weekArr[date] = calendar.component(.weekOfMonth, from: date)
        }
    }
    
    print("weekArr \(weekArr)")
    
    return weekArr
}

func calcTimeFrame(startDate: Date, returnDate: Date) -> [(Date, Int, String, String)] { // -> [Date: Int] {
    // calculate what nth week of the month
    // the entered date is
    // e.g. monday the 3rd is the -> "1st" Monday of the month
    
    // 1. get current year, month and day from the date
    // 2. get number of days in given month
    var calendar = Calendar(identifier: .gregorian)
//    calendar.firstWeekday = 2
    // Month number : weekday number
    var firstWeekDayOfMonths = [Int: Int]()
    let year = 2022
    print("First day of week: \(calendar.weekdaySymbols[calendar.firstWeekday - 1])")
    // create a dict with first weekday of each month
    // if the first weekday of a month is further on in the week than a day being calculated for,
    // then we know we can subtract one from the .weekOfMonth calculations for that day
    for month in 1...12 {
//        print(calendar.monthSymbols[month - 1])
        let first = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        if let range = calendar.range(of: .day, in: .month, for: first) {
            var currentWeek = -1
            for day in range {
                let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
                let week = calendar.component(.weekOfMonth, from: date)
                if week > currentWeek {
                    currentWeek = week
                    let dayOfWeek = calendar.component(.weekday, from: date)
//                    print("Week# \(week), weekday \(calendar.weekdaySymbols[dayOfWeek - 1])")
                    if week == 1 {
                        firstWeekDayOfMonths[month] = dayOfWeek
                    }
                }
            }
        }
    }
    // 11: 3 means November starts on a Tuesday (Sun,Mon,Tues)
    print("FIRST WEEKDAY OF MONTHS \(firstWeekDayOfMonths)")
    
    
    let startComponent = startDate.get(.day, .month, .year)
    let returnComponent = returnDate.get(.day, .month, .year)
    
    print("startDate \(startDate)")
    print("returnDate \(returnDate)")
    // get # days in given month
    let startRange = calendar.range(of: .day, in: .month, for: startDate)!
    let numDaysStart = startRange.count
    
    let returnRange = calendar.range(of: .day, in: .month, for: returnDate)!
    let numDaysReturn = returnRange.count
    
    var timeFrameDict = [(Date, Int, String, String)]()
    
    // getting dates between start and returnDate
    let dayDurationInSeconds: TimeInterval = 60*60*24
    for date in stride(from: startDate, to: returnDate, by: dayDurationInSeconds) {
        var theWeek = calendar.component(.weekOfMonth, from: date)
        print("date \(date) -- \(theWeek)")
        let theDay = date.dayOfWeek()!
        var grouping = ""
        
        let dayOfWeek = calendar.component(.weekday, from: date)
        print("dayOfWeek is \(dayOfWeek) --- \(firstWeekDayOfMonths[date.get(.month)])")
        if ( dayOfWeek < firstWeekDayOfMonths[date.get(.month)]!) {
            print("dayOfWeek less than first day of week in month")
            theWeek -= 1
        }
        
        switch theWeek {
        case 1:
            grouping = "2nd & 4th"
        case 2:
            grouping = "1st & 3rd"
        case 3:
            grouping = "2nd & 4th"
        case 4:
            grouping = "1st & 3rd"
        case 5:
            grouping = "Any Week"
        default:
            grouping = "Unknown Week"
        }
        
        if !["Saturday", "Sunday"].contains(theDay) {
            timeFrameDict.append((date, theWeek-1, grouping, theDay))
        }
    }
    print("timeFrameDict")
    for time in timeFrameDict {
        print(time)
    }
    
    // remove entries for "Any Week" if there are others later on for the same day that are NOT "Any Week"
    timeFrameDict = removeExtraAnyWeekEntries(timeFrameDict: timeFrameDict)
    
    // remove days that have both "1st & 3rd" and "2nd & 4th" in the timeFrameDict
    timeFrameDict = removeDuplicates(timeFrameDict: timeFrameDict)
    
    for tiem in timeFrameDict {
        print(tiem)
    }
    
    
    return timeFrameDict
    
//    HomeScreen().label1.text = "hello"
}

func removeDuplicates(timeFrameDict: [(Date, Int, String, String)]) -> [(Date, Int, String, String)] {
    var tmpTimeFrameDict = timeFrameDict
    
    // check if a weekday is there but then theres also a "2nd & 4th" or "1st & 3rd". if so, remove "Any Week"
    var weekDay13 = [String: Int]()
    var weekDay14 = [String: Int]()
//    var anyWeekIndices = [Int]()
    for (index, el) in tmpTimeFrameDict.enumerated() {
        if el.2 == "1st & 3rd" {
            weekDay13[el.3] = index
//            weekDay13.append([el.3: index])
//            anyWeekWeekdays.append(el.3)//timeFrameDict[index])
//            anyWeekIndices.append(index)
        }
        if el.2 == "2nd & 4th" {
            weekDay14[el.3] = index
        }
    }
    var removeIndices = [Int]()
    for (_, el) in tmpTimeFrameDict.enumerated() {
        if weekDay13[el.3] != nil && weekDay14[el.3] != nil {
            removeIndices.append(weekDay13[el.3]!)
            removeIndices.append(weekDay14[el.3]!)
        }
    }
    
    tmpTimeFrameDict.remove(at: removeIndices)
    
    return tmpTimeFrameDict
}

func removeExtraAnyWeekEntries(timeFrameDict: [(Date, Int, String, String)]) -> [(Date, Int, String, String)] {
    var tmpTimeFrameDict = timeFrameDict
    // check if an "Any Week" is there but then theres also a "2nd & 4th" or "1st & 3rd". if so, remove "Any Week"
    var anyWeekWeekdays = [String]()
    var anyWeekIndices = [Int]()
    for (index, el) in tmpTimeFrameDict.enumerated() {
        if el.2 == "Any Week" {
            anyWeekWeekdays.append(el.3)//timeFrameDict[index])
            anyWeekIndices.append(index)
        }
    }
    var removeIndices = [Int]()
    for (index, el) in tmpTimeFrameDict.enumerated() {
        if el.2 != "Any Week" {
            if let anyWeekIdx = anyWeekWeekdays.firstIndex(of: el.3) {
                removeIndices.append(index)
                tmpTimeFrameDict[anyWeekIndices[anyWeekIdx]] = tmpTimeFrameDict[index]
            }
        }
    }
    tmpTimeFrameDict.remove(at: removeIndices)
    
    return tmpTimeFrameDict
}


extension Array {
    mutating func remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: index)
            lastIndex = index
        }
    }
}

