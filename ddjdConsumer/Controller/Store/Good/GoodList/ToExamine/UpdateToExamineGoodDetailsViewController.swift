//
//  UpdateToExamineGoodDetailsViewController.swift
//  ddjdConsumer
//
//  Created by hao peng on 2018/1/18.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import TZImagePickerController
import SwiftyJSON
import SVProgressHUD
import ObjectMapper
///修改审核商品
class UpdateToExamineGoodDetailsViewController:FormViewController{
    var goodEntity:GoodEntity?
    struct Static {
        static let goodsCodeTag = "goodsCode"
        static let goodsNameTag = "goodsName"
        static let goodsUnitTag = "goodsUnit"
        static let goodUcodeTag = "goodUcode"
        static let goodsPriceTag = "goodsPrice"
        static let goodsLiftTag = "goodsLift"
        static let brandTag = "brand"
        static let goodsMixedTag = "goodsMixed"
        static let stockTag = "stock"
        static let purchasePriceTag = "purchasePrice"
        static let goodsFlagTag = "goodsFlag"
        static let categoryTag = "category"
        static let uploadImgTag = "uploadImg"
        static let button = "button"
        static let offlineStockTag = "offlineStock"
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        goodEntity=goodEntity ?? GoodEntity()
        if goodEntity!.examineGoodsFlag == 2{
            self.title="修改商品信息(审核失败)"
        }else{
            self.title="商品信息(\(goodEntity!.examineGoodsFlag == 1 ? "审核中":"审核成功"))"
        }
        self.loadForm()
        NotificationCenter.default.addObserver(self, selector:#selector(updateCategory), name: notificationNameCategorySelection, object:nil)
    }
    ///更新分类信息
    @objc private func updateCategory(not:Notification){
        let obj=not.userInfo
        if obj != nil{
            let json=JSON(obj!)
            goodEntity!.tCategoryId=json["tCategoryId"].intValue
            goodEntity!.sCategoryId=json["sCategoryId"].intValue
            goodEntity!.fCategoryId=json["fCategoryId"].intValue
            goodEntity!.goodsCategoryName=json["str"].stringValue
            if let cell = self.tableView.cellForRow(at:IndexPath(row:6,section:0)) as? FormLabelCell {
                cell.rowDescriptor?.value=goodEntity!.goodsCategoryName as AnyObject
                cell.update()
            }
        }
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}
extension UpdateToExamineGoodDetailsViewController{
    private func loadForm(){
        let form = FormDescriptor()
        let section1 = FormSectionDescriptor(headerTitle:"商品基本信息\(goodEntity!.examineInfo==nil ? "" :"(商品审核失败原因:\(goodEntity!.examineInfo!))")", footerTitle:"")
        var row = FormRowDescriptor(tag: Static.goodsCodeTag, type:.label, title: "商品条形码:")
        row.value=goodEntity!.goodsCode as AnyObject
        section1.rows.append(row)

        row=FormRowDescriptor(tag: Static.goodsNameTag, type: .text, title: "商品名称:")
        row.value=goodEntity!.goodsName as AnyObject
        row.configuration.cell.placeholder="请输入商品名称"
        section1.rows.append(row)

        row=FormRowDescriptor(tag:Static.purchasePriceTag, type:.decimal, title:"商品进货价:")
        row.value=goodEntity!.purchasePrice?.description as AnyObject
        row.configuration.cell.placeholder="请输入进货价"
        section1.rows.append(row)

        row=FormRowDescriptor(tag: Static.goodsPriceTag, type: .decimal, title: "商品零售价格:")
        row.value=goodEntity!.storeGoodsPrice?.description as AnyObject
        row.configuration.cell.placeholder="请输入商品零售价格"
        section1.rows.append(row)

        row=FormRowDescriptor(tag: Static.goodsUnitTag, type: .text, title: "商品单位:")
        row.value=goodEntity!.goodsUnit as AnyObject
        row.configuration.cell.placeholder="例如:包,瓶,厅,把,千克等"
        section1.rows.append(row)

        row=FormRowDescriptor(tag: Static.goodUcodeTag, type: .text, title: "商品规格:")
        row.value=goodEntity!.goodUcode as AnyObject
        row.configuration.cell.placeholder="例如:1*500g,1*200ml等"
        section1.rows.append(row)

        row=FormRowDescriptor(tag: Static.categoryTag, type: .label, title:"商品分类:")
        row.value=goodEntity!.goodsCategoryName as AnyObject
        row.configuration.cell.placeholder="请选择商品分类"
        row.configuration.button.didSelectClosure={ _ in
            let vc=CategorySelectionViewController()
            self.present(UINavigationController.init(rootViewController:vc), animated: true, completion:nil)
        }
        section1.rows.append(row)

        let section2 = FormSectionDescriptor(headerTitle:"商品其他信息", footerTitle:"说明:库存下限（总库存低于此值，线上此商品将显示已售罄)")
        row=FormRowDescriptor(tag: Static.goodsLiftTag, type: .number, title: "商品保质期:")
        row.value=goodEntity!.goodsLift?.description as AnyObject
        row.configuration.cell.placeholder="请输入商品保质期(天)"
        section2.rows.append(row)

        row=FormRowDescriptor(tag: Static.stockTag, type: .number, title: "商品库存:")
        row.value=goodEntity!.stock?.description as AnyObject
        row.configuration.cell.placeholder="请输入商品库存"
        section2.rows.append(row)

        row=FormRowDescriptor(tag: Static.offlineStockTag, type: .number, title: "库存下限:")
        row.value=goodEntity!.offlineStock?.description as AnyObject
        row.configuration.cell.placeholder="请输入库存下限"
        section2.rows.append(row)

        row = FormRowDescriptor(tag: Static.goodsFlagTag, type: .segmentedControl, title: "商品状态")
        row.configuration.selection.options = ([0, 1] as [Int]) as [AnyObject]
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? Int else { return "" }
            switch option {
            case 0:
                return "上架"
            case 1:
                return "下架"
            default:
                return ""
            }
        }
        row.value=goodEntity!.goodsFlag as AnyObject
        row.configuration.cell.appearance = ["titleLabel.font" : UIFont.systemFont(ofSize: 14),"segmentedControl.tintColor":UIColor.applicationMainColor()]
        section2.rows.append(row)

        row = FormRowDescriptor(tag:"ctime", type:.label, title:"提交审核时间:")
        row.value=goodEntity!.ctime as AnyObject
        section2.rows.append(row)

        let section3 = FormSectionDescriptor(headerTitle:"商品选填信息", footerTitle: nil)

        row=FormRowDescriptor(tag:Static.brandTag, type: .text, title: "商品品牌:")
        row.value=goodEntity!.brand as AnyObject
        row.configuration.cell.placeholder="请输入商品的品牌(选填)"
        section3.rows.append(row)

        row=FormRowDescriptor(tag: Static.goodsMixedTag, type: .text, title: "商品配料:")
        row.value=goodEntity!.goodsMixed as AnyObject
        row.configuration.cell.placeholder="请输入商品配料(选填)"
        section3.rows.append(row)

        let section4 = FormSectionDescriptor(headerTitle:"商品展示图片", footerTitle: nil)
        let uploadImgRow=FormRowDescriptor(tag: Static.uploadImgTag, type:.uploadImg,title:"")
        uploadImgRow.configuration.cell.placeholder="请选择商品图片"
        uploadImgRow.value=goodEntity!.goodsPic as AnyObject
        uploadImgRow.configuration.cell.cellClass = GoodUploadImgTableViewCell.self
        uploadImgRow.configuration.selection.optionTitleClosure = { value in
            let vc=TZImagePickerController.init(maxImagesCount:1, columnNumber:4, delegate:nil,pushPhotoPickerVc:true)
            //隐藏原图按钮
            vc?.allowPickingOriginalPhoto=false
            //用户不能选择视频
            vc?.allowPickingVideo=false
            vc?.showSelectBtn = false;
            vc?.allowCrop=true
            // 设置竖屏下的裁剪尺寸
            let widthHeight = boundsWidth - 60
            let top = (boundsHeight - widthHeight) / 2;
            vc?.cropRect = CGRect.init(x:30,y:top, width: widthHeight, height: widthHeight)
            vc?.didFinishPickingPhotosHandle={ (photos,assets,isSelectOriginalPhoto) in
                if photos!.count > 0{
                    uploadImgRow.value=photos![0] as AnyObject
                    if let cell = self.tableView.cellForRow(at:IndexPath(row:0,section:3)) as? GoodUploadImgTableViewCell {
                        cell.update()
                    }
                }
            }
            self.present(vc!, animated:true, completion:nil)
            return ""
        }
        section4.rows.append(uploadImgRow)

        let section5 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.button, type: .button, title:"确定修改")
        row.configuration.button.didSelectClosure = { _ in
            self.validateGoodInfo(formValues:self.form.formValues())
        }
        section5.rows.append(row)
        if goodEntity!.examineGoodsFlag == 2{
            form.sections = [section1,section2,section3,section4,section5]
        }else{
            form.sections = [section1,section2,section3,section4]

        }
        self.form=form
    }
    private func showInfo(withStatus:String){
        SVProgressHUD.showInfo(withStatus:withStatus)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.dismiss(withDelay:2)
    }
}
extension UpdateToExamineGoodDetailsViewController{
    private func validateGoodInfo(formValues:[String : AnyObject]){
        let json=JSON(formValues)

        goodEntity!.goodsCode=json[Static.goodsCodeTag].string
        goodEntity!.goodsName=json[Static.goodsNameTag].string
        goodEntity!.goodsUnit=json[Static.goodsUnitTag].string
        goodEntity!.goodsLift=Int(json[Static.goodsLiftTag].stringValue)
        goodEntity!.goodUcode=json[Static.goodUcodeTag].string
        goodEntity!.goodsPrice=Double(json[Static.goodsPriceTag].stringValue)
        goodEntity!.goodsFlag=json[Static.goodsFlagTag].intValue
        goodEntity!.stock=Int(json[Static.stockTag].stringValue)
        goodEntity!.purchasePrice=Double(json[Static.purchasePriceTag].stringValue)
        goodEntity!.brand=json[Static.brandTag].string
        goodEntity!.goodsMixed=json[Static.goodsMixedTag].string
        goodEntity!.goodsCategoryName=json[Static.categoryTag].string
        goodEntity!.offlineStock=Int(json[Static.offlineStockTag].stringValue)
        let image=formValues[Static.uploadImgTag] as? UIImage

        if goodEntity!.goodsName == nil || goodEntity!.goodsName!.count == 0{
            self.showInfo(withStatus:"商品名称不能为空")
            return
        }
        if goodEntity!.goodsUnit == nil || goodEntity!.goodsUnit!.count == 0{
            self.showInfo(withStatus:"商品单位不能为空")
            return
        }
        if goodEntity!.goodUcode == nil || goodEntity!.goodUcode!.count == 0{
            self.showInfo(withStatus:"商品规格不能为空")
            return
        }
        if goodEntity!.goodsPrice == nil || goodEntity!.goodsPrice! <= 0{
            self.showInfo(withStatus:"商品零售价格不能为空/不能为0")
            return
        }
        if goodEntity!.goodsCategoryName == nil || goodEntity!.goodsCategoryName!.count == 0{
            self.showInfo(withStatus:"请选择商品分类")
            return
        }
        if goodEntity!.goodsLift == nil || goodEntity!.goodsLift! <= 0{
            self.showInfo(withStatus:"保质期不能为空/不能为0")
            return
        }
        if goodEntity!.stock == nil || goodEntity!.stock! <= 0{
            self.showInfo(withStatus:"商品库存不能为空/不能为0")
            return
        }
        if goodEntity!.offlineStock == nil{
            self.showInfo(withStatus:"库存下限不能为空")
            return
        }
        if goodEntity!.offlineStock! >= goodEntity!.stock!{
            self.showInfo(withStatus:"库存下限不能大于等于库存")
            return
        }
        if goodEntity!.purchasePrice == nil || goodEntity!.purchasePrice! <= 0{
            self.showInfo(withStatus:"进货价不能为空/不能为0")
            return
        }
        if image == nil{
            self.showInfo(withStatus:"请选择商品图片")
            return
        }
        self.uploadGoodImg(img:image!)
    }
    private func uploadGood(goodsPic:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(target:StoreGoodApi.updateExamineGoodsByStoreId(examineGoodsId:goodEntity!.examineGoodsId ?? 0,goodsCode:goodEntity!.goodsCode!, storeId:STOREID, goodsName: goodEntity!.goodsName!, goodsUnit:goodEntity!.goodsUnit!, goodsLift: goodEntity!.goodsLift!,goodUcode:goodEntity!.goodUcode!, fCategoryId:goodEntity!.fCategoryId ?? 0, sCategoryId: goodEntity!.sCategoryId ?? 0, tCategoryId:goodEntity!.tCategoryId ?? 0, goodsPic:goodsPic,goodsPrice:"\(goodEntity!.goodsPrice!)", goodsFlag:goodEntity!.goodsFlag!+1,stock:goodEntity!.stock ?? 0,remark:nil, weight:nil,brand:goodEntity!.brand,goodsMixed:goodEntity!.goodsMixed,purchasePrice:goodEntity!.purchasePrice!.description,offlineStock:goodEntity!.offlineStock ?? 0), successClosure: { (json) in
            
            let success = json["success"].stringValue
            if success == "success"{
                SVProgressHUD.dismiss()
                ///通知审核商品列表刷新页面
                NotificationCenter.default.post(name:notificationNameUpdateStoreToExamineGoodList,object:nil)
                
                UIAlertController.showAlertYes(self, title:"", message:"商品成功提交审核；请等待审核结果", okButtonTitle:"确定", okHandler: { (action) in
                    self.navigationController?.popViewController(animated:true)
                })
            }else if success == "notExist"{
                SVProgressHUD.showInfo(withStatus:"审核信息不存在")
            }else if success == "examineGoodsFlag"{
                SVProgressHUD.showInfo(withStatus:"状态不是审核失败，不能修改")
            }else if success == "offlineStockMaxError"{
                SVProgressHUD.showInfo(withStatus:"库存下限填写的数量不能等于或超过库存")
            }else{
                self.showInfo(withStatus:"上传商品信息失败")
            }
            SVProgressHUD.setDefaultMaskType(.none)
        }) { (error) in
            SVProgressHUD.showError(withStatus:error)
            SVProgressHUD.setDefaultMaskType(.none)
        }
        //删除本地图片
        deleteUploadImgFile()
    }
    private func uploadGoodImg(img:UIImage){
        SVProgressHUD.show(withStatus:"正在上传商品...")
        SVProgressHUD.setDefaultMaskType(.clear)
        let filePath=UIImage.saveImage(img,newSize:CGSize(width:boundsWidth, height:boundsWidth),percent:1)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(target:StoreGoodApi.start(filePath:filePath,pathName:"goodsImages"), successClosure: { (json) in
            let success=json["success"].stringValue
            if success == "success"{
                let path=json["path"].stringValue
                self.uploadGood(goodsPic:path)
            }else{
                SVProgressHUD.showError(withStatus:"上传失败,请重新上传")
                SVProgressHUD.setDefaultMaskType(.none)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus:error)
            SVProgressHUD.setDefaultMaskType(.none)
            return
        }
    }
}
