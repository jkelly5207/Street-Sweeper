//
//  ViewController.swift
//  Street Sweeper
//
//  Created by Jason Kelly on 11/27/22.
//

import UIKit
import JTAppleCalendar

class DateHeader: JTACMonthReusableView {
    @IBOutlet weak var monthTitle: UILabel!
}

class HomeScreen: UIViewController, JTACMonthViewDelegate, JTACMonthViewDataSource {

    @IBOutlet weak var JTAppleCalView: JTACMonthView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    var labelArray : [UILabel] = []
    let testCalendar = Calendar(identifier: .gregorian)
    
    @IBOutlet weak var streetsButton: UIButton!
    
    var firstDate: Date?
    var secondDate: Date?
    var dateRange = [Date]()
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && JTAppleCalView.selectedDates.count > 1
    }
    
    var dateModel = DateModel(parkDate: Date())
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JTAppleCalView.ibCalendarDelegate = self
        JTAppleCalView.ibCalendarDataSource = self
        JTAppleCalView.allowsRangedSelection = true
        JTAppleCalView.allowsMultipleSelection = true
        
        JTAppleCalView.scrollDirection = .horizontal
        JTAppleCalView.scrollingMode   = .stopAtEachCalendarFrame
        JTAppleCalView.showsHorizontalScrollIndicator = false
        
        topNotchMask(color: UIColor(red: 78.0/255.0, green: 77.0/255.0, blue: 126.0/255.0, alpha: 1.0))
        bottomNotchMask(color: UIColor(red: 78.0/255.0, green: 77.0/255.0, blue: 126.0/255.0, alpha: 1.0))
        
        // Do any additional setup after loading the view.
        let today = Date()
        labelArray = [label1, label2, label3, label4, label5]
        for label in labelArray {
            label.text = ""
        }
        for (index, el) in labelArray.enumerated() {
            el.text = "\(dateModel.timeFrameDict[index].2) "
            // \(dateModel.timeFrameDict[index].3.uppercased()):
        }
        
        datePicker.contentHorizontalAlignment = .center
        datePicker.date = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        
        formatDate(theDate: today, theLabel: dateLabel)
        calcNthWeekOfMonth(dayOfMonth: datePicker.date)
    }
    
    @IBAction func streetButtonTapped(_ sender: UIButton) {
        
    }
    //    @objc func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
//        let point = gesture.location(in: gesture.view!)
//        let rangeSelectedDates = JTAppleCalView.selectedDates
//
//        guard let cellState = JTAppleCalView.cellStatus(at: point) else { return }
//
//        if !rangeSelectedDates.contains(cellState.date) {
//            let dateRange = JTAppleCalView.generateDateRange(from: rangeSelectedDates.first ?? cellState.date, to: cellState.date)
//            JTAppleCalView.selectDates(dateRange, keepSelectionIfMultiSelectionAllowed: true)
//        } else {
//            let followingDay = testCalendar.date(byAdding: .day, value: 1, to: cellState.date)!
//            JTAppleCalView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
//        }
//    }
    
    func formatDate(theDate: Date, theLabel: UILabel? = nil) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let label = theLabel {
            label.text = "\(dateFormatter.string(from: theDate))"
        }
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
       guard let cell = view as? DateCell  else { return }
       cell.dateLabel.text = cellState.text
       handleCellTextColor(cell: cell, cellState: cellState)
       handleCellSelected(cell: cell, cellState: cellState)
    }
        
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
       if cellState.dateBelongsTo == .thisMonth {
          cell.dateLabel.textColor = UIColor.white
       } else {
          cell.dateLabel.textColor = UIColor.gray
       }
    }

    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        switch cellState.selectedPosition() {
        case .left:
            cell.selectedView.layer.borderWidth = 2
            cell.selectedView.layer.borderColor = UIColor.systemMint.cgColor
            cell.selectedView.layer.backgroundColor = UIColor.clear.cgColor
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .middle:
            cell.selectedView.layer.borderWidth = 2
            cell.selectedView.layer.borderColor = UIColor.systemMint.cgColor
            cell.selectedView.layer.backgroundColor = UIColor.clear.cgColor
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = []
        case .right:
            cell.selectedView.layer.borderWidth = 2
            cell.selectedView.layer.borderColor = UIColor.systemMint.cgColor
            cell.selectedView.layer.backgroundColor = UIColor.clear.cgColor
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .full:
            cell.selectedView.layer.borderWidth = 2
            cell.selectedView.layer.borderColor = UIColor.systemMint.cgColor
            cell.selectedView.layer.backgroundColor = UIColor.clear.cgColor
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        default: break
        }
    }
    
    
    
    @IBAction func datePickerSet(_ sender: UIDatePicker) {
        print("calc new date ... \(sender.date)")
        if sender.date > dateModel.parkDate {
            dateModel.returnDate = sender.date
        }
        
        for (index, el) in labelArray.enumerated() {
            el.text = "\(dateModel.timeFrameDict[index].2) \(dateModel.timeFrameDict[index].3)"
        }
    }
}


extension HomeScreen {
    func configureCalendar(_ calendar: JTAppleCalendar.JTACMonthView) -> JTAppleCalendar.ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"

        let startDate = Date()
        
        let components = Date().endOfMonth().get(.day, .month, .year)
        var endDate = formatter.date(from: "2023 12 31")!
        if let day = components.day, let month = components.month, let year = components.year {
            endDate = formatter.date(from: "\(year+1) \(month) \(day)")!
        }
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid)
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)) ~= self
    }
}

extension HomeScreen {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
       return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM"
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    //  selection stuff
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let dayOfWeek = dayOfWeek(cell: cell, calendar: calendar)
        print("dayOfWeek \(dayOfWeek)")
        var firstWeek = false
   
        let components = date.get(.day, .month, .year)
        if let day = components.day {
            if day < 7 {
                firstWeek = true
            }
        }
      
        // from here you should be able to calculate the first day of the month
        // then that would get you the ability to know what week every day of the month is
        
        
        if firstDate != nil && secondDate != nil {
            calendar.deselectAllDates()
            firstDate = date
            secondDate = nil
        } else if firstDate != nil {
            secondDate = date
            // calculate the weeks
            let theTimeFrame = calcTimeFrame(startDate: firstDate!, returnDate: date)
            for (idx, el) in labelArray.enumerated() {
                el.text = ""
            }
            for (index, el) in theTimeFrame.enumerated() {
//                if index < labelArray.count {
//                    labelArray[index].text = "\(theTimeFrame[index].2) "
//                }
                switch theTimeFrame[index].3 {
                case "Monday":
                    labelArray[0].text = "\(theTimeFrame[index].2)"
                case "Tuesday":
                    labelArray[1].text = "\(theTimeFrame[index].2)"
                case "Wednesday":
                    labelArray[2].text = "\(theTimeFrame[index].2)"
                case "Thursday":
                    labelArray[3].text = "\(theTimeFrame[index].2)"
                case "Friday":
                    labelArray[4].text = "\(theTimeFrame[index].2)"
                default:
                    labelArray[index].text = "\(theTimeFrame[index].2)"
                }
            }
            
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
        }
        configureCell(view: cell, cellState: cellState)
    }
    
    func dayOfWeek(cell: JTACDayCell?, calendar: JTACMonthView) -> String {
        let realCenter = calendar.convert(cell!.center, to: calendar.superview)
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = cell!.frame.size.width
        let numCellsPerRow = round(screenWidth / cellWidth)
        let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        for val in 0...Int(numCellsPerRow) {
            print("value is \(val)")
            if realCenter.x > CGFloat(val)*cellWidth && realCenter.x < CGFloat(val+1)*cellWidth {
                print("between \(val) and \(val+1)")
                return days[val]
            }
        }
        return "Unknown"
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState) -> Bool {
        print("shouldSelectDate function")
        if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < JTAppleCalView.selectedDates[0] {
            print("setting firstDate to nil")
            firstDate = nil
            let retval = !JTAppleCalView.selectedDates.contains(date)
            JTAppleCalView.deselectAllDates()
            return retval
        }
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) -> Bool {
        print("shouldDeselect ... twoalready selected ? \(twoDatesAlreadySelected)")
        if twoDatesAlreadySelected && cellState.selectionType != .programatic {
            print("setting firstDate to nil")
            firstDate = nil
            JTAppleCalView.deselectAllDates()
            return false
        }
        return true
    }

}
