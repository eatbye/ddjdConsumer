//
//  StoreGoodListTableViewCell.swift
//  ddjdConsumer
//
//  Created by hao peng on 2017/12/8.
//  Copyright © 2017年 zltx. All rights reserved.
//

import UIKit
import Kingfisher
///店铺商品列表cell
class StoreGoodListTableViewCell: UITableViewCell {
    ///商品图片
    @IBOutlet weak var goodImg: UIImageView!
    ///库存
    @IBOutlet weak var lblStock: UILabel!
    ///商品名称
    @IBOutlet weak var lblGoodName: UILabel!
    ///商品价格
    @IBOutlet weak var lblStoreGoodsPrice: UILabel!
    ///商品单位
    @IBOutlet weak var lblGoodsUnit: UILabel!
    ///商品销量
    @IBOutlet weak var lblSalesCount: UILabel!
    ///商品上下架
    @IBOutlet weak var scGoodsFlag: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    func updateCell(entity:GoodEntity){
        lblGoodName.text=entity.goodsName
        lblGoodsUnit.text="/\(entity.goodsUnit ?? "")"
        lblStock.text="库存:\(entity.stock ?? 0)"
        lblSalesCount.text="销量\(entity.salesCount ?? 0)"
        lblStoreGoodsPrice.text="￥\(entity.storeGoodsPrice ?? 0.0)"
        entity.goodsPic=entity.goodsPic ?? ""
        goodImg.kf.setImage(with:URL(string:urlImg+entity.goodsPic!), placeholder:UIImage(named:goodDefaultImg), options:[.transition(ImageTransition.fade(1))])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}