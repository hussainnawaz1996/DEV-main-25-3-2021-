//
//  String+Extension.swift
//  Movo
//
//  Created by Ahmad on 29/10/2020.
//

import UIKit

extension String {
    /// Sets the attributedText property of UILabel with an attributed string
    /// that displays the characters of the text at the given indices in subscript.
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluate(with: self)
    }
    
    func splitedBy(length: Int) -> [String] {
        
        var result = [String]()
        
        for i in stride(from: 0, to: self.count, by: length) {
            let endIndex = self.index(self.endIndex, offsetBy: -i)
            let startIndex = self.index(endIndex, offsetBy: -length, limitedBy: self.startIndex) ?? self.startIndex
            result.append(String(self[startIndex..<endIndex]))
        }
        
        return result.reversed()
        
    }
    
    func stringByReplacingFirstOccurrenceOfString(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    
    func indexInt(of char: Character) -> [Int] {
        var indicesArray = [Int]()
        var temp = self
        for character in temp {
            if character == char {
                let index = firstIndex(of: char)?.utf16Offset(in: self)
                temp = temp.stringByReplacingFirstOccurrenceOfString(target: String(char), withString: "")
                if let ind = index {
                    indicesArray.append(ind)
                }
            }
        }
        
        return indicesArray
//        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
              !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    var indicesOfSuperscripts: [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        while searchStartIndex < self.endIndex,
              let range = self.rangeOfCharacter(from: CharacterSet.decimalDigits,
                                                range: searchStartIndex..<self.endIndex),
              !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            if index > 0 {
                let previousIndex = self.index(self.startIndex, offsetBy: index - 1)
                if let previousCharacter = self[previousIndex].unicodeScalars.first,
                   (previousCharacter == "." || previousCharacter == ",")
                {
                    indices.append(index - 1)
                }
            }
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        return indices
    }
    
    func checkLowerCased() -> Bool {
        let lowerLetterRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        let lowerResult = texttest.evaluate(with: self)
        return lowerResult
    }
    
    func checkCapital() -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        return capitalresult
    }
    
    func checkNumber() -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: self)
        return numberresult
    }
    
    func checkSpecialCharacters() -> Bool {
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: self)
        return specialresult
    }
    
    func check8Plus() -> Bool {
        return self.count > 8
    }
    
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
                .range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func getMSISDNFromString() -> String? {
        let okayChars : Set<Character> = Set("1234567890+")
        
        var result = self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.regularExpression, range:nil).trimmingCharacters(in: CharacterSet.whitespaces)
        
        result = String(result.filter {okayChars.contains($0) })
        if result.hasPrefix("+") {
            return result
        }
        
        var msisdn = result
        if result.hasPrefix("00"){
            msisdn.removeFirst()
            msisdn.removeFirst()
        }else if result.hasPrefix("0"){
            msisdn.removeFirst()
        }
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            let callingCode = IsoCountryCodes.find(key: countryCode).calling
            print(callingCode)
            msisdn = callingCode+msisdn
        }
        
        return msisdn
    }
    
//    func getMSISDNFromString2() -> (countryCode: String?, phoneNumber:String?) {
//        let okayChars : Set<Character> = Set("1234567890+")
//
//        var result = self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.regularExpression, range:nil).trimmingCharacters(in: CharacterSet.whitespaces)
//
//        result = String(result.filter {okayChars.contains($0) })
//        if result.hasPrefix("+") {
//            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//                let callingCode = IsoCountryCodes.find(key: countryCode).calling
////                let codeStr = "\(callingCode)"
////                for (_, _) in codeStr.enumerated() {
////                    result.removeFirst()
////                }
//                return (callingCode, result)
//            }
//        }
//
//        var msisdn = result
//        if result.hasPrefix("00"){
//            msisdn.removeFirst()
//            msisdn.removeFirst()
//        }else if result.hasPrefix("0"){
//            msisdn.removeFirst()
//        }
//
//        var callingCode = ""
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//            callingCode = IsoCountryCodes.find(key: countryCode).calling
//            msisdn = callingCode+msisdn
//            msisdn = msisdn.trimmingCharacters(in: .whitespacesAndNewlines)
//            msisdn = msisdn.replacingOccurrences(of: "-", with: "")
//        }
//
//        return (callingCode, msisdn)
//    }
    
    func getMSISDNFromString2() -> (countryCode: String?, phoneNumber:String?) {
        let okayChars : Set<Character> = Set("1234567890+")
        
        var result = self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.regularExpression, range:nil).trimmingCharacters(in: CharacterSet.whitespaces)
        
        result = String(result.filter {okayChars.contains($0) })
        if result.hasPrefix("+") {
            let countryCode = getCountryCode()
            return (countryCode, result)
        }
        
        var msisdn = result
        msisdn = msisdn.trimmingCharacters(in: .whitespacesAndNewlines)
        msisdn = msisdn.replacingOccurrences(of: "-", with: "")
        msisdn = msisdn.replacingOccurrences(of: "(", with: "")
        msisdn = msisdn.replacingOccurrences(of: ")", with: "")
        
        let countryCode = getCountryCode()
        if countryCode == "+1" {
                        
            if result.hasPrefix("00"){
                msisdn.removeFirst()
                msisdn.removeFirst()
                msisdn = "+" + msisdn
            } else if result.hasPrefix("0"){
                msisdn.removeFirst()
                msisdn = countryCode + msisdn
            } else {
                if msisdn.count == StandardLengths.US_PHONE {
                    msisdn = "+" + msisdn
                } else {
                    msisdn = countryCode + msisdn
                }
            }
            return (countryCode, msisdn)
        } else {
            
            if result.hasPrefix("00"){
                msisdn.removeFirst()
                msisdn.removeFirst()
                msisdn = "+" + msisdn
            } else if result.hasPrefix("0"){
                msisdn.removeFirst()
                msisdn = countryCode + msisdn
            } else {
                if msisdn.count == StandardLengths.PAK_PHONE {
                    msisdn = "+" + msisdn
                } else {
                    msisdn = countryCode + msisdn
                }
            }
            
            return (countryCode, msisdn)
            
        }
        
    }
    
    private func getCountryCode() -> String {
        var callingCode = ""
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            callingCode = IsoCountryCodes.find(key: countryCode).calling
        }
        return callingCode
    }
    
    func getOriginalLocalDate() -> Date{

        let startIndex = self.index(self.startIndex, offsetBy: 0)
        let endIndex = self.index(self.startIndex, offsetBy: 18)
        let substring = self[startIndex...endIndex]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        
        let convertedlocalTime = String(substring).UTCToLocal()
        dateFormatter.locale = DateFormats.EN_US_POSIX
        let localDate = dateFormatter.date(from: convertedlocalTime)

        return localDate!
    }
    
    func getLocalDate() -> Date{
        let validStr = getValidDateStr(str: self as! String)

        let startIndex = validStr.index(validStr.startIndex, offsetBy: 0)
        let endIndex = validStr.index(validStr.startIndex, offsetBy: 18)
        let substring = validStr[startIndex...endIndex]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        
//        let convertedlocalTime = String(substring).UTCToLocal()
//        dateFormatter.locale = DateFormats.EN_US_POSIX
//        let localDate = dateFormatter.date(from: convertedlocalTime)
        let localDate = dateFormatter.date(from: validStr)

        return localDate!
    }
    
    func getDateFromString() -> Date{
        let validStr = getValidDateStr(str: self as! String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        let localDate = dateFormatter.date(from: validStr)
        
        return localDate!
    }
    
    func localToUTC() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.locale = DateFormats.EN_US_POSIX
        
        let dt = dateFormatter.date(from: self as! String)
        dateFormatter.timeZone = DateFormats.UTC_TIME_ZONE
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        dateFormatter.locale = DateFormats.EN_US_POSIX
        let utcDate = dateFormatter.string(from: dt ?? Date())
        return utcDate
    }
    
    func UTCToLocal() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        dateFormatter.timeZone = DateFormats.UTC_TIME_ZONE
        dateFormatter.locale = DateFormats.EN_US_POSIX
        let dt = dateFormatter.date(from: self as! String)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DateFormats.DATE_TIME_FORMAT
        let localDate = dateFormatter.string(from: dt ?? Date())
        return localDate
    }
    
    func getHistoryDateStr() -> String {
        let validStr = getValidDateStr(str: self as! String)
        let localDate = validStr.getLocalDate()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormats.MMMddyyyy
        let resultStr = dateFormater.string(from: localDate)
        return resultStr
    }
    
    func getCardExpiryDateStr() -> String {
        let validStr = getValidDateStr(str: self as! String)
        let localDate = validStr.getLocalDate()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormats.MMyy
        let resultStr = dateFormater.string(from: localDate)
        return resultStr
    }
    
    func getDateStr() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = DateFormats.UTC_TIME_ZONE
        formatter.locale = DateFormats.EN_US_POSIX
        formatter.dateFormat = DateFormats.EMMMdyyyy
        let dateStr = formatter.string(from: self.getLocalDate())
        return dateStr
    }
    
    func getOnlyDateStr() -> String {
        var dateStr = ""
        let scheduledDateStr = self
        if let onlyDate = scheduledDateStr.components(separatedBy: "T").first {
            dateStr = onlyDate + "T00:00:00"
        }
        
        return dateStr
    }
    
    //2020-01-01T00:00:00
    //2020-01-01
    //2020/01/01
    //2020/01/01T00:00:00
    func getValidDateStr(str: String) -> String {
        var resultStr = ""
        if str.contains("T") {
            if var firstDateComponent = str.components(separatedBy: "T").first {
                if firstDateComponent.contains("-") {
                    resultStr = firstDateComponent + "T00:00:00"
                } else if firstDateComponent.contains("/") {
                    firstDateComponent = firstDateComponent.replacingOccurrences(of: "/", with: "-")
                    resultStr = firstDateComponent + "T00:00:00"
                }
            }
        } else {
            var temp = str
            temp = temp.replacingOccurrences(of: "/", with: "-")
            resultStr = str + "T00:00:00"
        }
        
        return resultStr
    }
    
    func generateQRCode() -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func get2DigitDecimalString() -> String {
        if let doubleValue = Double(self) {
            return doubleValue.numberFormatter(digitAfterPoint: 2)
        } else {
            return "0.00"
        }
    }
}
