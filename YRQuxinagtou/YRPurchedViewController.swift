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
    private let productIDs = ["zs50", "zs100", "zs300", "zs800", "zs1000", "zs2000"]
    private let productTilte = ["50", "100", "300", "800", "1000", "2000"]
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
        let themedImage = UIImage.pureColor(YRConfig.themeTintColored!)
        navigationController?.navigationBar.setBackgroundImage(themedImage, forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .whiteColor()
        setUpViews()
//        loadData()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        readyforPayment()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
        let themedImage = UIImage.pureColor(YRConfig.themeTintColored!)
        navigationController?.navigationBar.setBackgroundImage(themedImage, forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .whiteColor()
        
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
//    private func loadData() {
//        YRService.requiredDiamonds(success: { (result) in
//            if let data = result!["data"] {
//                self.diamonds = Diamonds(fromJSONDictionary: data as! [String : AnyObject])
//            }
//            }, fail: { error in
//                print("required Diamonds error:\(error)")
//        })
//    }
    
    func readyforPayment() {
        guard SKPaymentQueue.canMakePayments() else {
            YRAlertHelp.showAutoAlertCancel(title: "警告", message: "未能允许支付", cancelAction: nil, inViewController: self)
            return
        }
    }
    
    func requestProductData(id: String) {
        
        let productSet:Set<String> = [id]
        let productRequest = SKProductsRequest(productIdentifiers: productSet)
        productRequest.delegate = self
        productRequest.start()
    }
    
    // 验证凭据，获取到苹果返回的交易凭据
    private func verifyPruchase(){
        print(#function)

        let receiptURL = NSBundle.mainBundle().appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOfURL: receiptURL!)
        if (receiptData == nil) { /* No local receipt -- handle the error. */
            print("do not load receive receiptData")
        }else {
            let base64String = receiptData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            let receiptDict:[String : String] = ["receipt-data" : base64String]
            print(receiptDict)
            YRService.verifyPayments(receipt: receiptDict, success: { (result) in
                //MARK: TODo here
                YRProgressHUD.hideActivityIndicator()
                print("result \(result.debugDescription)")
                }, fail: { error in
                YRProgressHUD.hideActivityIndicator()
                    print(" pusrched verity error:\(error)")
            })
        }
    }
}

extension YRPurchedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productIDs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiamondCell") as! DiamondCell
        let title = self.productTilte[indexPath.row]
        cell.nameLb.text = title + " 趣币"
        cell.priceLb.text = "¥ " + title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DiamondCell
        let productId = self.productIDs[indexPath.row]
        cell.priceLb.layer.borderColor = UIColor.redColor().CGColor
        cell.priceLb.textColor = UIColor.redColor()
        YRProgressHUD.showActivityIndicator()
        self.isPaying = true
        requestProductData(productId)
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
        YRProgressHUD.showActivityIndicator()
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        guard self.isPaying else { return }
        
        YRProgressHUD.hideActivityIndicator()
        for transaction in transactions {
            let state = transaction.transactionState
            switch state {
            case .Purchased:
                print(state.rawValue)
                print(" puerched  ")
                YRProgressHUD.showActivityIndicator()
                self.verifyPruchase()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case .Purchasing:
                print(state.rawValue)
                print(" purcheding ")
                YRProgressHUD.showActivityIndicator()
//                self.verifyPruchase()
//                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case .Restored:
                print(state.rawValue)
                YRProgressHUD.showActivityIndicator()
//                self.verifyPruchase()
                SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
            case .Failed:
                print(" ❌❌❌ failled purched: \(transaction.error) ")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case .Deferred:
                YRProgressHUD.showActivityIndicator()
                print(state.rawValue)
//                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                YRProgressHUD.hideActivityIndicator()
            }
        }
    }
}


private class DiamondCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(nameLb)
        contentView.addSubview(imgV)
        contentView.addSubview(priceLb)
        let viewsDict = ["nameLb" : nameLb,
                         "imgV" : imgV,
                         "priceLb" : priceLb]
        let vflDict = ["H:|-[imgV(30)]-[nameLb]-[priceLb(60)]-|",
                       "V:|-12-[imgV(30)]",
                        "V:[priceLb(20)]"
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllTrailing, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    
    let nameLb: UILabel = {
        let label = UILabel()
        label.text = "2000 趣币"
        label.numberOfLines = -1
        label.preferredMaxLayoutWidth = 180.0
        label.font = UIFont.systemFontOfSize(15.0)
        label.textAlignment = .Left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLb: UILabel = {
        let label = UILabel()
        label.text = "¥ 1888.00"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(16.0)
        label.textColor = YRConfig.mainTextColored
        label.layer.borderWidth = 1.0
        label.layer.borderColor = YRConfig.disabledColored.CGColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 3.0
        label.layer.masksToBounds = true
        return label
    }()
    
    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "money_Icon")
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
