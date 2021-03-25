//
//  GetCardAccountsResponseModel.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import Foundation

// MARK: - GetCardAccountsResponseModel
struct GetCardAccountsResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: CardAccountModel?
}

// MARK: - DataClass
struct CardAccountModel: Codable {
    let responseCode, responseDesc: String?
    let cards: [CardModel]?
    let transID, arn, clerkID, fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, cards
        case transID = "transId"
        case arn, clerkID, fee
    }
}

// MARK: - Card
struct CardModel: Codable {
    let isPrimaryCardSpecified: Bool?
    var ccv: String?
    let cardNumber, referenceID, cardCategory, productType: String?
    let customerID, primaryCardNumber, primaryCardReferenceID, purseSourceCardNumber: String?
    let purseSourceCardReferenceID, followMeCardNo, followMeCardReferenceID, sourceCardNo: String?
    let sourceCardReferenceNo, cardProgramID, programAbbreviation, cardDesignID: String?
    let cardLogoID: String?
    let accountType: Int?
    let accountTypeSpecified: Bool?
    let firstName, middleName, lastName, memberNumber: String?
    let lastDepositDate, lastDepositAmount, expiryDate, statusCode: String?
    let isRegistered: Int?
    let isRegisteredSpecified: Bool?
    let balance: String?
    let ledgerBalance: Double?
    let ledgerBalanceSpecified, daysOfDueDateSpecified: Bool?
    let currencyCode, billingCurrencyCode: String?
    let allocatedCreditLimitSpecified, outstandingBalanceSpecified, outstandingLedgerBalanceSpecified, cashAdvanceBalanceSpecified: Bool?
    let cashAdvanceLedgerBalanceSpecified, availableCreditLimitSpecified, availableLegderCreditLimitSpecified, availableCashAdvanceLimitSpecified: Bool?
    let ledgerCashAdvanceCreditLimitSpecified, pendingTransactionsBalanceSpecified, allocatedCashAdvanceLimitSpecified: Bool?
    let stmtDayOfMonth, stakeholderID, achProcessingDays: String?
    let purchaseAPRSpecified, cashAdvanceAPRSpecified, statementDateSpecified: Bool?
    let deliveryMethod, delinquentTotalDays: String?
    let delinquentDueAmountSpecified: Bool?

    enum CodingKeys: String, CodingKey {
        case isPrimaryCardSpecified, ccv, cardNumber, referenceID, cardCategory, productType
        case customerID = "customerId"
        case primaryCardNumber, primaryCardReferenceID, purseSourceCardNumber, purseSourceCardReferenceID, followMeCardNo, followMeCardReferenceID, sourceCardNo, sourceCardReferenceNo, cardProgramID, programAbbreviation
        case cardDesignID = "cardDesignId"
        case cardLogoID = "cardLogoId"
        case accountType, accountTypeSpecified, firstName, middleName, lastName, memberNumber, lastDepositDate, lastDepositAmount, expiryDate, statusCode, isRegistered, isRegisteredSpecified, balance, ledgerBalance, ledgerBalanceSpecified, daysOfDueDateSpecified, currencyCode, billingCurrencyCode, allocatedCreditLimitSpecified, outstandingBalanceSpecified, outstandingLedgerBalanceSpecified, cashAdvanceBalanceSpecified, cashAdvanceLedgerBalanceSpecified, availableCreditLimitSpecified, availableLegderCreditLimitSpecified, availableCashAdvanceLimitSpecified, ledgerCashAdvanceCreditLimitSpecified, pendingTransactionsBalanceSpecified, allocatedCashAdvanceLimitSpecified, stmtDayOfMonth
        case stakeholderID = "stakeholderId"
        case achProcessingDays, purchaseAPRSpecified, cashAdvanceAPRSpecified, statementDateSpecified, deliveryMethod, delinquentTotalDays, delinquentDueAmountSpecified
    }
}
