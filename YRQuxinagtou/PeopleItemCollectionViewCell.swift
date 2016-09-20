//
//  PeopleItemCollectionViewCell.swift
//  YRQuxinagtou
//
//  Created by Meng Ye on 16/9/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class PeopleItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var online: UIImageView!
    @IBOutlet weak var certificate: UIImageView!
    @IBOutlet weak var status: UIImageView!
    
    func configureMatched(one: MatchedOne) {
        nickname.text = one.nickname
        let url = NSURL(string: one.avatar!)
        avatar.kf_showIndicatorWhenLoading = true
        avatar.kf_setImageWithURL(url!)
    }
    
    func configureLikedMe(one: LikedMeOne) {
        nickname.text = one.nickname
        let url = NSURL(string: one.avatar!)
        avatar.kf_showIndicatorWhenLoading = true
        avatar.kf_setImageWithURL(url!)
    }
}
