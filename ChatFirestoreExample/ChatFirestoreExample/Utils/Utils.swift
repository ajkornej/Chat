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
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second],
                                               from: earliest, to: latest)
        
        guard let year = components.year,
              let month = components.month,
              let week = components.weekOfYear,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute else {
            return "Только что"
        }
        
        // Логика формирования русских фраз
        func pluralForm(n: Int, form1: String, form2: String, form5: String) -> String {
            let n = abs(n) % 100
            let n1 = n % 10
            if n >= 11 && n <= 19 { return form5 }
            if n1 == 1 { return form1 }
            if n1 >= 2 && n1 <= 4 { return form2 }
            return form5
        }

        if year >= 2 {
            return "\(year) \(pluralForm(n: year, form1: "год", form2: "года", form5: "лет")) назад"
        } else if year >= 1 {
            return numericDates ? "1 год назад" : "В прошлом году"
        } else if month >= 2 {
            return "\(month) \(pluralForm(n: month, form1: "месяц", form2: "месяца", form5: "месяцев")) назад"
        } else if month >= 1 {
            return numericDates ? "1 месяц назад" : "В прошлом месяце"
        } else if week >= 2 {
            return "\(week) \(pluralForm(n: week, form1: "неделю", form2: "недели", form5: "недель")) назад"
        } else if week >= 1 {
            return numericDates ? "1 неделю назад" : "На прошлой неделе"
        } else if day >= 2 {
            return "\(day) \(pluralForm(n: day, form1: "день", form2: "дня", form5: "дней")) назад"
        } else if day >= 1 {
            return numericDates ? "1 день назад" : "Вчера"
        } else if hour >= 2 {
            return "\(hour) \(pluralForm(n: hour, form1: "час", form2: "часа", form5: "часов")) назад"
        } else if hour >= 1 {
            return numericDates ? "1 час назад" : "Час назад"
        } else if minute >= 2 {
            return "\(minute) \(pluralForm(n: minute, form1: "минуту", form2: "минуты", form5: "минут")) назад"
        } else if minute >= 1 {
            return numericDates ? "1 минуту назад" : "Минуту назад"
        } else {
            return "Только что"
        }
    }
}
