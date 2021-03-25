//
//  ShareFundsRequestModel.swift
//  Movo
//
//  Created by Ahmad on 24/11/2020.
//

import Foundation

// MARK: - ShareFundsRequestModel
struct ShareFundsRequestModel: Codable {
    let fromReferenceID: String
    let amount: Double
    let toPhoneOrEmail:String
    let comments: String?
    
    enum CodingKeys: String, CodingKey {
        case fromReferenceID = "fromReferenceId"
        case amount, toPhoneOrEmail, comments
    }
}


// MARK: - ShareFundsResponseModel
struct ShareFundsResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: ShareFundModel?
}

// MARK: - DataClass
struct ShareFundModel: Codable {
    let responseCode, responseDesc, cardNumber, cardReferenceID: String?
    let newCardNumber: NewCardNumber?
    let newCardReferenceID, upgradedCardNumber, upgradedCardReferenceID: String?
    let sharingCards: [SharingCard]?
    let pin, pinOffset: String?
    let status: Status?
    let fromCardBalance, toCardBalance, cvV2, balance: String?
    let ledgerBalanceSpecified, amountRequestedSpecified, amountProcessedSpecified, partialFundsFlagSpecified: Bool?
    let partialPointsFlagSpecified, pointsRequestedSpecified, pointsRedeemedSpecified, pointsBalanceSpecified: Bool?
    let pointsExchangeRateSpecified, pointsAmountSpecified, isRegisteredSpecified: Bool?
    let offers: Offers?
    let lastDepositDate, lastDepositAmount, transID, arn: String?
    let clerkID, customerID, cardProgramName, fee: String?
    let referenceID, expiryDate, batchReferenceID, fundsExpiryDate: String?
    let isBadPINTriesExceededSpecified, transitionFlagSpecified: Bool?
    let newCardExpiryDate, newCardCVV2, nameOnCard, virtualCardNumber: String?
    let maaSubUnSubRespDesc: String?
    
    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, cardNumber, cardReferenceID, newCardNumber, newCardReferenceID, upgradedCardNumber, upgradedCardReferenceID, sharingCards, pin, pinOffset, status, fromCardBalance, toCardBalance, cvV2, balance, ledgerBalanceSpecified, amountRequestedSpecified, amountProcessedSpecified, partialFundsFlagSpecified, partialPointsFlagSpecified, pointsRequestedSpecified, pointsRedeemedSpecified, pointsBalanceSpecified, pointsExchangeRateSpecified, pointsAmountSpecified, isRegisteredSpecified, offers, lastDepositDate, lastDepositAmount
        case transID = "transId"
        case arn, clerkID
        case customerID = "customerId"
        case cardProgramName, fee, referenceID, expiryDate, batchReferenceID, fundsExpiryDate, isBadPINTriesExceededSpecified, transitionFlagSpecified, newCardExpiryDate, newCardCVV2, nameOnCard, virtualCardNumber, maaSubUnSubRespDesc
    }
}

// MARK: - NewCardNumber
struct NewCardNumber: Codable {
    let number, accountNumber, balance, expiryDate: String?
}

// MARK: - Offers
struct Offers: Codable {
    let totalOffersRedeemed: Int?
    let totalOffersRedeemedSpecified: Bool?
    let totalRedeemedAmount: Int?
    let totalRedeemedAmountSpecified: Bool?
    let offer: [Offer]?
}

// MARK: - Offer
struct Offer: Codable {
    let icouponProgramID, couponProgramDesc, couponNo: String?
    let couponValue: Int?
    let couponValueSpecified: Bool?
    let availableCouponValue: Int?
    let availableCouponValueSpecified: Bool?
    let couponValueRedeemed: Int?
    let couponValueRedeemedSpecified: Bool?
    let couponStatus, couponType, packageID, packageName: String?
    let packageData, acquirerID, merchantID: String?
    let minPurchaseAmount: Int?
    let minPurchaseAmountSpecified: Bool?
    let maxRedemptionCount: String?
    let isPartialRedemption: Int?
    let isPartialRedemptionSpecified: Bool?
    let isMultiOffer: Int?
    let isMultiOfferSpecified: Bool?
    let basis: Int?
    let basisSpecified: Bool?
    let percentage: Int?
    let percentageSpecified: Bool?
    let effectiveDateFrom, expirationPeriodType, expirationPeriodValue, startTime: String?
    let endTime, daysOfWeek, daysOfMonth, monthsOfYear: String?
    
    enum CodingKeys: String, CodingKey {
        case icouponProgramID = "icouponProgramId"
        case couponProgramDesc, couponNo, couponValue, couponValueSpecified, availableCouponValue, availableCouponValueSpecified, couponValueRedeemed, couponValueRedeemedSpecified, couponStatus, couponType, packageID, packageName, packageData, acquirerID, merchantID, minPurchaseAmount, minPurchaseAmountSpecified, maxRedemptionCount, isPartialRedemption, isPartialRedemptionSpecified, isMultiOffer, isMultiOfferSpecified, basis, basisSpecified, percentage, percentageSpecified, effectiveDateFrom, expirationPeriodType, expirationPeriodValue, startTime, endTime, daysOfWeek, daysOfMonth, monthsOfYear
    }
}

// MARK: - SharingCard
struct SharingCard: Codable {
    let sharingCardNumber, sharingCardReferenceID: String?
}

// MARK: - Status
struct Status: Codable {
    let code, statusDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case statusDescription = "description"
    }
}
