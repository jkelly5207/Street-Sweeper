//
//  Extensions.swift
//  Street Sweeper
//
//  Created by Jason Kelly on 11/27/22.
//

import UIKit
import JTAppleCalendar

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

extension UIViewController {
    func topNotchMask(color: UIColor) {
        let colouredTop = UIView()
         view.addSubview(colouredTop)
         colouredTop.translatesAutoresizingMaskIntoConstraints = false
         colouredTop.backgroundColor = color

         NSLayoutConstraint.activate([
            colouredTop.topAnchor.constraint(equalTo: view.topAnchor),
            colouredTop.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            colouredTop.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    func bottomNotchMask(color: UIColor) {
        let colouredView = UIView()
        view.addSubview(colouredView)
        colouredView.translatesAutoresizingMaskIntoConstraints = false
        colouredView.backgroundColor = color

         NSLayoutConstraint.activate([
            colouredView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), 
            colouredView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colouredView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
}

extension UIView {
    func maskOutNotch(topColor:UIColor? = nil, bottomColor:UIColor? = nil) {
        let height:CGFloat = 50
        
        func makeBlock(color:UIColor)->UIView {
            let blockView = UIView()
            blockView.translatesAutoresizingMaskIntoConstraints = false
            blockView.backgroundColor = color
            blockView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            blockView.heightAnchor.constraint(equalToConstant: height).isActive = true
            //blockView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            return blockView
        }
        
        let safeArea = self.safeAreaLayoutGuide
        
        if let topCol = topColor {
            print("TOPCOL \(topCol)")
            let topView = makeBlock(color: topCol)
            self.addSubview(topView)
            topView.bottomAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        }
        if let bottomCol = bottomColor {
            let bottomView = makeBlock(color: bottomCol)
            self.addSubview(bottomView)
            bottomView.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
        }
        
        self.needsUpdateConstraints()
    }
}


