//
//  IAPService.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/7/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation
import StoreKit

let subID = "com.MarcusHoutzager.DataServiceMonthly"

class IAPService: SKReceiptRefreshRequest, SKProductsRequestDelegate{
    
    static let instance = IAPService()
    var productRequest = SKProductsRequest()
    var products = [SKProduct]()
    var productIDs = Set<String>()
    var expirationDate = UserDefaults.standard.value(forKey: "expirationDate") as? Date
    

    //APP delegate calls load products
    func loadProducts(){
        productIDs.insert(subID)
        requestProducts(forIDs: productIDs)
    }
    
    // start a product request
    func requestProducts(forIDs IDs: Set<String>){
        productRequest.cancel()
        productRequest = SKProductsRequest(productIdentifiers: IDs)
        productRequest.delegate = self
        productRequest.start()
    }
    
    //get back all products
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        debugPrint("response.products : ", response.products.description)
        if products.count == 0{
            requestProducts(forIDs: productIDs)
        }else{
            print(products[0].localizedTitle)
        }
    }
    
    //add payment to que
    func attemptPurchaseofSubscription(){
        if products.count > 0 {
            let product = products[0]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }else{
            print("No products found")
        }
    }
    
    
    func requestDidFinish(_ request: SKRequest) {
        uploadReceipt { (valid) in
            if valid {
                //check to see if subscription is still active
                debugPrint("SUBSCRIPTION VALID")
                self.isSubscriptionActive(completionHandler: { (active) in
                    if active{
                        debugPrint("SUBSCRIPTION ACTIVE")
                        NotificationCenter.default.post(name: NSNotification.Name("SubChange"), object: true)
                    }else{
                        NotificationCenter.default.post(name: NSNotification.Name("SubChange"), object: false)
                        debugPrint("SUBSCRIPTION EXPIRED")
                    }
                })
            }else{
                debugPrint("SUBSCRIPTION INVALID")
                NotificationCenter.default.post(name: NSNotification.Name("SubChange"), object: false)
            }
        }
    }
    
    func isSubscriptionActive(completionHandler: @escaping (Bool) -> Void){
        expirationDate = UserDefaults.standard.value(forKey: "expirationDate") as? Date
        debugPrint("ExpirationDate: ", expirationDate)
        let nowDate = Date()
        guard let expirationDate =  expirationDate else { completionHandler(false); return }
        if nowDate.isLessThan(expirationDate){
            completionHandler(true)
        }else{
            completionHandler(false)
        }
        
    }
    
    func uploadReceipt(completionHandler: @escaping(Bool) ->Void){
        guard let receiptUrl = Bundle.main.appStoreReceiptURL, let receipt = try? Data(contentsOf: receiptUrl).base64EncodedString() else {
            debugPrint("No receipt url")
            completionHandler(false)
            return
        }
        let secret = "6b196ea535f746d5adc1881336602bf9"
        let body = [
            "receipt-data": receipt,
            "password": secret
        ]
        
        let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
        
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            if let error = error {
                debugPrint("ERROR : ", error)
                completionHandler(false)
            } else if let responseData = responseData{
                let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as!
                    Dictionary<String, Any>
                let newExpirationDate = self.expirationDateFromResponse(jsonResponse: json)
                self.setExpiration(forDate: newExpirationDate!)
                debugPrint("NEW EXPIRTATION DATE: ", newExpirationDate!)
                //print(json)
                completionHandler(true)
            }
        }
        task.resume()
    }
    
    func expirationDateFromResponse(jsonResponse: Dictionary<String, Any>) -> Date? {
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray{
            let lastReceipt = receiptInfo.lastObject as! Dictionary<String, Any>
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            let expirationDate: Date = (formatter.date(from: lastReceipt["expires_date"] as! String))!
            return expirationDate
        }else{
            return nil
        }
    }
    
    func setExpiration(forDate date:Date ){
        UserDefaults.standard.set(date, forKey: "expirationDate")
    }
}

extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                AuthService.instance.subscribeUser();
                uploadReceipt { (valid) in
                    if valid{
                        debugPrint("Subscription is valid")
                    }else{
                        debugPrint("Subscription is not valid")
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name("SubChange"), object: true)
                debugPrint("Purchase was successfull")
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            default:
                break
            }
        }
    }

}
