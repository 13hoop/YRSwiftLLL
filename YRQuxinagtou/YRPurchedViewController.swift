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

    var diamonds: Diamonds? {
        didSet {
            if let items = diamonds?.list {
                list = items
            }
        }
    }
    var list: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var isPaying: Bool = false
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
        
        loadData()
        
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
    private func loadData() {
        YRService.requiredDiamonds(success: { (result) in
            if let data = result!["data"] {
                self.diamonds = Diamonds(fromJSONDictionary: data as! [String : AnyObject])
            }
        }, fail: { error in
            print("required Diamonds error:\(error)")
        })
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
            print("  identifer📈📈📈: \(identifer)")            
            guard let plainData = (identifer as NSString).dataUsingEncoding(NSUTF8StringEncoding) else {
                fatalError(" transaction.transactionIdentifier encoding error ")
            }
            
            let base64String = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            print(base64String)
            let receiptDict:[String : String] = ["receipt-data" : base64String]
            
            YRService.verifyPayments(receipt: receiptDict, success: { (result) in
//                
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
        return self.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiamondCell") as! DiamondCell
        let model = self.list[indexPath.row]
        cell.nameLb.text = model.name
        if let priceStr = model.price {
            cell.priceLb.text = "¥ " + priceStr
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        YRProgressHUD.showActivityIndicator()
        self.isPaying = true
        requestProductData()
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
        guard self.isPaying else { return }
        
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


private class DiamondCell: UITableViewCell {
    
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
        label.text = "2000 趣币"
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









