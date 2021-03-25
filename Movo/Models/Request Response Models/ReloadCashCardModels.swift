//
//  ReloadCashCardModels.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import Foundation


// MARK: - ReloadCashCardRequestModel
struct ReloadCashCardRequestModel: Codable {
    let primaryReferenceID, cashCardReferenceID: String?
    let amount: String?

    enum CodingKeys: String, CodingKey {
        case primaryReferenceID = "primaryReferenceId"
        case cashCardReferenceID = "cashCardReferenceId"
        case amount
    }
}

struct UnloadCashCardRequestModel: Codable {
    let primaryReferenceID, cashCardReferenceID: String?
    let amount: String?

    enum CodingKeys: String, CodingKey {
        case primaryReferenceID = "primaryReferenceId"
        case cashCardReferenceID = "cashCardReferenceId"
        case amount
    }
}


// MARK: - ReloadCashCardResponseModel
struct ReloadCashCardResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: ReloadResponseModel?
}

// MARK: - DataClass
struct ReloadResponseModel: Codable {
    let responseCode, responseDesc, cardNumber, cardReferenceID: String?
    let newCardNumber: JSONNull?
    let newCardReferenceID, upgradedCardNumber, upgradedCardReferenceID: String?
    let sharingCards: JSONNull?
    let pin, pinOffset: String?
    let status: JSONNull?
    let fromCardBalance, toCardBalance, cvV2, balance: String?
    let ledgerBalanceSpecified, amountRequestedSpecified, amountProcessedSpecified, partialFundsFlagSpecified: Bool?
    let partialPointsFlagSpecified, pointsRequestedSpecified, pointsRedeemedSpecified, pointsBalanceSpecified: Bool?
    let pointsExchangeRateSpecified, pointsAmountSpecified, isRegisteredSpecified: Bool?
    let offers: JSONNull?
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
