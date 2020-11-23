//
//  MediaLibray_ViewController.swift
//  敢聊播放器
//
//  Created by hong on 2019/1/17.
//  Copyright © 2019 Great. All rights reserved.
//

//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit

//class MediaLibray_ViewController: UIViewController {
//    let vm = MediaLibrayVM()
//    let disposeBag = DisposeBag()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(mediaLibrayTBV)
//        self.layoutPageViews()
//        
//        
//        
//        //初始化数据
//        let items = Observable.just(self.vm.mediaListArray)
//        
//        //设置单元格数据（其实就是对 cellForRowAt 的封装）
//        items
//            .bind(to: mediaLibrayTBV.rx.items) { (mediaLibrayTBV, row, element) in
//                let cell = mediaLibrayTBV.dequeueReusableCell(withIdentifier: "Cell")!
//                let mediaModel = self.vm.mediaListArray[row]
//                cell.textLabel?.text = mediaModel.name
//                return cell
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    func layoutPageViews() {
//        mediaLibrayTBV.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
//        }
//    }
//    
//    //MARK: - Setter && Getter
//    lazy var mediaLibrayTBV: UITableView = {
//        let mediaLibrayTBV = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
//    mediaLibrayTBV.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
//        mediaLibrayTBV.backgroundColor=UIColor.red
//        mediaLibrayTBV.frame=CGRect(x: 100, y: 100, width: 100, height: 40)
//        return mediaLibrayTBV
//    }()
//}


/**
 Medialibrary 准备媒体模型（本地模型对比操作）
 播放器重写，页面触屏操作优化
 */
