//
//  Date+EasyAdd.swift
//  EasyKit
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

///日期单位
public enum EasyDateUnit: Int, Comparable {
    ///年
    case year = 6
    ///月
    case month = 5
    ///日
    case day = 4
    ///时
    case hour = 3
    ///分
    case minute = 2
    ///秒
    case second = 1
    ///毫秒
    case nanosecond = 0
    public static func < (lhs: EasyDateUnit, rhs: EasyDateUnit) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
///日期值
public enum EasyDateValue: Equatable {
    ///年
    case year(Int)
    ///月
    case month(Int)
    ///日
    case day(Int)
    ///时
    case hour(Int)
    ///分
    case minute(Int)
    ///秒
    case second(Int)
    ///毫秒
    case nanosecond(Int)
}
///常用格式化参数
public enum EasyDateFormat: CustomStringConvertible {
    case date(_ separator: String)
    case time(_ separator: String)
    case datetime(_ dateSeparator:String,_ timeSeparator:String,_ partSeparator: String)
    public var description: String {
        switch self {
        case let .date(sp): return "yyyy\(sp)MM\(sp)dd"
        case let .time(sp): return "HH\(sp)mm\(sp)ss"
        case let .datetime(s1,s2,s3): return "yyyy\(s1)MM\(s1)dd\(s3)HH\(s2)mm\(s2)ss"
        }
    }
}
extension EasyDateFormat {
    ///yyyy-MM-dd
    public static var date: EasyDateFormat { return .date("-")}
    ///HH:mm:ss
    public static var time: EasyDateFormat { return .time(":")}
    ///yyyy-MM-dd HH:mm:ss
    public static var datetime: EasyDateFormat { return .datetime("-", ":", " ")}
}

extension EasyCoding where Base == Date {
    ///转成objc对象
    public var objc: NSDate {
        return self.base as NSDate
    }
    ///实例
    public static func instance(_ values: EasyDateValue...) -> Date {
        var components = DateComponents()
        for value in values {
            switch value {
            case let .year(value): components.year = value
            case let .month(value): components.month = value
            case let .day(value): components.day = value
            case let .hour(value): components.hour = value
            case let .minute(value): components.minute = value
            case let .second(value): components.second = value
            case let .nanosecond(value): components.nanosecond = value
            }
        }
        
        return Calendar.current.date(from: components)!
    }
    public func string(_ format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone? = nil, locale: Locale? = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let tz = timeZone {
            formatter.timeZone = tz
        }
        formatter.locale = locale
        return formatter.string(from: self.base)
    }
    public func format(_ format: EasyDateFormat) -> String {
        return self.string(format.description)
    }
    ///两个日期相差
    public func since(_ date: Date, for unit: EasyDateUnit) -> Int {
        switch unit {
        case .nanosecond: return Int(self.base.timeIntervalSince(date) * 1000)
        case .second: return Int(self.base.timeIntervalSince(date))
        case .minute: return Int(self.base.timeIntervalSince(date) / 60)
        case .hour: return Int(self.base.timeIntervalSince(date) / 60 / 60)
        case .day:
            let comp = Set<Calendar.Component>(arrayLiteral: Calendar.Component.day)
            return Calendar.current.dateComponents(comp, from: date, to: self.base).day ?? 0
        case .month:
            let comp = Set<Calendar.Component>(arrayLiteral: Calendar.Component.month)
            return Calendar.current.dateComponents(comp, from: date, to: self.base).month ?? 0
        case .year:
            let comp = Set<Calendar.Component>(arrayLiteral: Calendar.Component.year)
            return Calendar.current.dateComponents(comp, from: date, to: self.base).year ?? 0
        }
    }
}
extension EasyCoding where Base == String {
    ///实例
    public func date(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self.base) ?? Date()
    }
    ///实例
    public func date(format: EasyDateFormat) -> Date {
        return self.date(format.description)
    }
}
extension EasyCoding where Base == TimeInterval {
    ///将秒显示为天时分秒的剩余时长描述，start至少为天, fixed代表固定会出现的单位，若高于fixed的单位值为0时不出现
    public func remainingDuration(_ endDesc:String = "已结束",start: EasyDateUnit = .day, end: EasyDateUnit = .minute, fixed: EasyDateUnit = .hour) -> String {
        let timeString = NSMutableString()
        var time = self.base
        if time > 0 {
            let day = Int(time / 24 / 60 / 60)
            time = time - Double(day * 24 * 60 * 60)
            let hour = Int(time / 60 / 60)
            time = time - Double(hour * 60 * 60)
            let minute = Int(time / 60)
            time = time - Double(minute * 60)
            let second = Int(time)
            time = time - Double(second)
            let nanosecond = Int(time * 1000)
            
            if start >= .day {
                if day > 0 {
                    timeString.append("\(day)天")
                }else if fixed >= .day{
                    timeString.append("0天")
                }
            }
            if start >= .hour && end <= .hour {
                if hour > 0 {
                    timeString.append(hour >= 10 ? "\(hour)时" : "0\(hour)时")
                }else if fixed >= .hour {
                    timeString.append("00时")
                }
            }
            if start >= .minute && end <= .minute {
                if minute > 0 {
                    timeString.append(minute >= 10 ? "\(minute)分" : "0\(minute)分")
                }else if fixed >= .minute {
                    timeString.append("00分")
                }
            }
            if start >= .second && end <= .second {
                if second > 0 {
                    timeString.append(second >= 10 ? "\(second)秒" : "0\(second)秒")
                }else if fixed >= .second {
                    timeString.append("00秒")
                }
            }
            if start >= .nanosecond && end <= .nanosecond {
                if nanosecond > 100 {
                    timeString.append("\(nanosecond)毫秒")
                }else if nanosecond > 10 {
                    timeString.append("0\(nanosecond)毫秒")
                }else if nanosecond > 0 {
                    timeString.append("00\(nanosecond)毫秒")
                }else if fixed >= .nanosecond {
                    timeString.append("000毫秒")
                }
            }
        }else{
            timeString.append(endDesc)
        }
        return timeString as String
    }
    ///转为时：分：秒的显示格式
    public func timeString(withChinese: Bool = false) -> String {
        let timeString = NSMutableString()
        var time = self.base
        let separators = withChinese ? ["小时","分","秒"] : [":",":",""]
        if time > 0 {
            let hour = Int(time / 60 / 60)
            time = time - Double(hour * 60 * 60)
            let minute = Int(time / 60)
            time = time - Double(minute * 60)
            let second = Int(time)
            time = time - Double(second)
            //            let nanosecond = Int(time * 1000)
            if hour > 0 {
                if withChinese {
                    timeString.append("\(hour)\(separators[0])")
                }else{
                    timeString.append(hour >= 10 ? "\(hour)\(separators[0])" : "0\(hour)\(separators[0])")
                }
            }
            if minute > 0 {
                timeString.append(minute >= 10 ? "\(minute)\(separators[1])" : "0\(minute)\(separators[1])")
            }else {
                timeString.append("00\(separators[1])")
            }
            if second > 0 {
                timeString.append(second >= 10 ? "\(second)\(separators[2])" : "0\(second)\(separators[2])")
            }else {
                timeString.append("00\(separators[2])")
            }
        }else{
            timeString.append("00\(separators[1])00\(separators[2])")
        }
        return timeString as String
    }
}
