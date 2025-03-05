//
//  Utils.swift
//  ChatFirestoreExample
//
//  Created by Alisa Mylnikova on 19.06.2023.
//

import SwiftUI

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

extension View {
    func font(_ size: CGFloat, _ color: Color = .black, _ weight: Font.Weight = .regular) -> some View {
        self
            .fontWeight(weight)
            .font(.system(size: size))
            .foregroundColor(color)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    func toURL() -> URL? {
        URL(string: self)
    }
}

extension Date {
    func timeAgoFormat(numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let date = self
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if components.year! >= 2 {
            return "\(components.year!) лет назад"
        } else if components.year! >= 1 {
            if numericDates {
                return "1 год назад"
            } else {
                return "В прошлом году"
            }
        } else if components.month! >= 2 {
            return "\(components.month!) месяцев назад"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 месяц назад"
            } else {
                return "В прошлом месяце"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) недель назад"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 неделю назад"
            } else {
                return "На прошлой неделе"
            }
        } else if components.day! >= 2 {
            return "\(components.day!) дней назад"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 день назад"
            } else {
                return "Вчера"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) часов назад"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 час назад"
            } else {
                return "Час назад"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) минут назад"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 минуту назад"
            } else {
                return "Минуту назад"
            }
        } else {
            return "Только что"
        }
    }
}
