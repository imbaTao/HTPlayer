//
//  MediaLibrayVM.swift
//  WhatsPlayer
//
//  Created by hong  on 2019/2/4.
//  Copyright © 2019 Great. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class MediaLibrayVM: NSObject {

    var mediaListArray = [MediaModel1]()
    override init() {
        // 取出来未过滤的数组
       mediaListArray = LD.analyzeRomMediafiles(path: documentPath)
        
        //初始化数据
//        let items = Observable.just(mediaListArray)
    }
}
