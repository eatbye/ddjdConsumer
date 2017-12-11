//
//  BindStoreViewController.swift
//  ddjdConsumer
//
//  Created by hao peng on 2017/12/4.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
///绑定店铺
class BindStoreViewController:BaseViewController{
    //扫码绑定
    @IBOutlet weak var btnSweepCodeBind: UIButton!
    //搜索绑定
    @IBOutlet weak var btnManualOperationBind: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavColor()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reinstateNavColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="绑定门店"
        btnSweepCodeBind.layer.borderColor=UIColor.white.cgColor
        btnSweepCodeBind.layer.borderWidth=1
        btnSweepCodeBind.layer.cornerRadius=5
        btnSweepCodeBind.addTarget(self, action:#selector(sweepCodeBindStore), for: UIControlEvents.touchUpInside)
        btnManualOperationBind.layer.borderWidth=1
        btnManualOperationBind.layer.cornerRadius=5
        btnManualOperationBind.layer.borderColor=UIColor.white.cgColor
        btnManualOperationBind.addTarget(self, action:#selector(searchBindStore), for: UIControlEvents.touchUpInside)
    }
    //设置导航栏颜色
    private func setUpNavColor(){
        self.navigationController?.navigationBar.barTintColor=UIColor.applicationMainColor()
        self.navigationController?.navigationBar.titleTextAttributes=NSDictionary(object:UIColor.white, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any]
        self.navigationController?.navigationBar.tintColor=UIColor.white
        //恢复导航栏黑线颜色
        self.navigationController?.navigationBar.shadowImage=UIImage.imageFromColor(UIColor.applicationMainColor())
    }
    //恢复导航栏颜色
    private func reinstateNavColor(){
        self.navigationController?.navigationBar.tintColor=UIColor.applicationMainColor()
        self.navigationController?.navigationBar.barTintColor=UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes=NSDictionary(object:UIColor.applicationMainColor(), forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any]
        //恢复导航栏黑线颜色
        self.navigationController?.navigationBar.shadowImage=nil
    }
    ///扫码绑定店铺
    @objc private func sweepCodeBindStore(){
        
    }
    ///搜索绑定店铺
    @objc private func searchBindStore(){
        let vc=self.storyboardPushView(type:.my, storyboardId:"UpdateAddAddressInfoVC") as! UpdateAddAddressInfoViewController
        vc.bindStoreFlag=1
        vc.flag=1
        self.navigationController?.pushViewController(vc, animated:true)
    }
}