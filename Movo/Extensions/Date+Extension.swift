//
//  Date+Extension.swift
//  Movo
//
//  Created by Ahmad on 29/10/2020.
//

import Foundation

extension Date {
    func getEventDisplayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.mm_dd_yyyy
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func getStringFromDate() -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        return dateFormatter.string(from: self)
        
    }
    
    func getZeroTimeOnlyDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        let str = dateFormatter.string(from: self)
        
        let validStr = str.getValidDateStr(str: str)
        return validStr
    }
    
    func convertTimeToUTC() -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = DateFormats.EN_US_POSIX
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        dateFormatter.timeZone = DateFormats.UTC_TIME_ZONE
        return dateFormatter.string(from: self)
    }
    
    func getDisplayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.MMMddyyyy
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}
