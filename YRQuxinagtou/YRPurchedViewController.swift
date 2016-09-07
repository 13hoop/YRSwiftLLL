//
//  YRPurchedViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import StoreKit

class YRPurchedViewController: UIViewController {

    var heightAdviewConstraint: NSLayoutConstraint?
    private lazy var adView: AdView = {
        let view = AdView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(DiamondCell.self, forCellReuseIdentifier: "DiamondCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50.0
        tableView.tableFooterView = UIView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "充值"
        view.backgroundColor = YRConfig.plainBackgroundColored
        setUpViews()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        readyforPayment()
    }
    
    deinit {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    private func setUpViews() {
        view.addSubview(adView)
        view.addSubview(tableView)
        
        let viewsDict = ["tableView" : tableView,
                         "adView" : adView]
        let vflDict = ["H:|-0-[adView]-0-|",
                       "H:|-0-[tableView]-0-|",
                       "V:|-0-[adView]-0-[tableView]-0-|"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        heightAdviewConstraint =  NSLayoutConstraint(item: adView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30)
        view.addConstraint(heightAdviewConstraint!)
    }
    
    func readyforPayment() {
        guard SKPaymentQueue.canMakePayments() else {
            YRAlertHelp.showAutoAlertCancel(title: "警告", message: "未能允许支付", cancelAction: nil, inViewController: self)
            return
        }
    }
    
    let productId: String = "zs1000"
    func requestProductData() {
        
        let productSet:Set<String> = [productId]
        let productRequest = SKProductsRequest(productIdentifiers: productSet)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func completeTrabsaction(transaction : SKPaymentTransaction) {
    
        if let identifer = transaction.transactionIdentifier {
            // 编码格式 待验证
            print("  identifer📈📈📈: \(identifer)")
            let receiptDict:[String : String] = ["receipt-data" : "MTAwMDAwMDIzNDM5OTg0MQ=="]
            
            YRService.verifyPayments(receipt: receiptDict, success: { (result) in
                
                let a = "todo"
                print(result)
            }, fail: { error in
                    
                print(" pusrched verity error:\(error)")
            })
            SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        }
    }
}

extension YRPurchedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiamondCell") as! DiamondCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        YRProgressHUD.showActivityIndicator()
        requestProductData()
    }
}

class DiamondCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(nameLb)
        contentView.addSubview(imgV)
        contentView.addSubview(priceLb)
        
        let viewsDict = ["nameLb" : nameLb,
                         "imgV" : imgV,
                         "priceLb" : priceLb]
        let vflDict = ["H:|-[imgV(30)]-[nameLb]-[priceLb]-|",
                       "V:|-12-[imgV(30)]"
        ]

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllTrailing, metrics: nil, views: viewsDict))
    }
    
    
    let nameLb: UILabel = {
        let label = UILabel()
        label.text = "2000 钻"
        label.numberOfLines = -1
        label.preferredMaxLayoutWidth = 180.0
        label.font = UIFont.systemFontOfSize(16.0)
        label.textAlignment = .Left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLb: UILabel = {
        let label = UILabel()
        label.text = "¥ 1888.00"
        label.textAlignment = .Right
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = YRConfig.mainTextColored
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension YRPurchedViewController: SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        print(" receive product response:\(response.products)  ")
        
        let product = response.products
        guard product.count > 0 else {
            fatalError(" no product, check id ")
        }
        
        var paymentOp: SKPayment?
        for obj in product {
            
            print(" receive product response:\(obj.productIdentifier)  ")
            guard obj.productIdentifier == self.productId else { return }
            paymentOp = SKPayment(product: obj)
        }
        
        SKPaymentQueue.defaultQueue().addPayment(paymentOp!)
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print(#function)
        fatalError("\(error)")
    }
    
    func requestDidFinish(request: SKRequest) {
        print(#function)
        YRProgressHUD.hideActivityIndicator()
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            let state = transaction.transactionState
            switch state {
            case .Purchased:
                print(state.rawValue)
                print("   puerched  ")
                self.completeTrabsaction(transaction)
                
            case .Purchasing:
                print(state.rawValue)
                print(" purcheding ")

            case .Restored:
                print(state.rawValue)
            case .Failed:
                
                print(" failled purched ")
                
            case .Deferred:
                print(state.rawValue)
            }
        }
    }
}








