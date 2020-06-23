//
//  LocalDataHelper.swift
//  FileTool
//
//  Created by hong  on 2019/2/2.
//  Copyright © 2019 HZY. All rights reserved.
//

import Foundation
import CoreData

class MediaInfo: NSObject {
    var name = ""
    var url = ""
    var media = VLCMedia()
    var length = 0
    var isDirectory = false
    init(name: String, url: String, isDirectory: Bool) {
        self.name = name
        self.url = url
        self.isDirectory = isDirectory
    }
}


// 单例
let LD = LocalDataHelper()

// 根目录
let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0]


class LocalDataHelper {
    // 上下文
    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        return context
    }()
    
    // 初始化时创建数据库
    init() {
        do {
            try FileManager.default.removeItem(atPath: documentPath + "/" + ".DataBase")
        }catch{}
        // 获取模型地址
        let modelUrl = Bundle.main.url(forResource: "MediaDataBase", withExtension: "momd")
        
        if modelUrl != nil {
            //根据模型文件创建模型对象
            let model = NSManagedObjectModel.init(contentsOf: modelUrl!)
            
            //利用模型对象创建助理对象
            let store = NSPersistentStoreCoordinator.init(managedObjectModel: model!)
            
            
            // 数据库的名称和路径
            let documentDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
            
            // 根路径
            let baseUrl = documentDir.appendingPathComponent(".DataBase/coreData.sqlite", isDirectory: false)
            let urlStr = baseUrl.path
            if !FileManager.default.fileExists(atPath: urlStr){
                do {
                    try FileManager.default.createDirectory(at: documentDir.appendingPathComponent(".DataBase"), withIntermediateDirectories: false, attributes: nil)
                    
                    try store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: baseUrl, options: nil)

                    self.context.persistentStoreCoordinator = store
                }catch{
                    return
                }
            }
        }
    }
    
    // 根据路径string遍历返回|创建模型
    func analyzeRomMediafiles(path: String) -> [MediaModel1] {
        // 文件管理
        let fileManager = FileManager.default;
        
        // 文件夹遍历
        let directoryEnum = fileManager.enumerator(atPath: path)
        
        // 本地待定的媒体数组
        var undeterminedInfoArray = [MediaInfo]();
        
        // 文件夹名数组
        var directoryNameArray = [String]();
        
        // 本地确定有的媒体数组
        var confirmArray = [MediaModel1]();
        if directoryEnum != nil {
            for fileName in directoryEnum! {
                let name = fileName as! String
                let url = documentPath + "/" + name
                
                // 创建一个bool值
                var isDirectory: ObjCBool =  false
                fileManager.fileExists(atPath:url, isDirectory: &isDirectory)
                
                // 如果不包含特殊字符的过滤
                if  !url.contains("DataBase") && !url.contains(".DS_Store"){
                    
                    // 创建获取请求
                    let fetchRequest: NSFetchRequest = MediaModel1.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                    do {
                        // 如果找到了就是唯一的
                        let result: [MediaModel1] = try LD.context.fetch(fetchRequest)
                        if result.count != 0 {// 如果有取出来
                            confirmArray.append(result.first!)
                        }else{
                            // 是否是文件夹
                            if isDirectory.boolValue  {
                                if  !directoryNameArray.contains(name){
                                    directoryNameArray.append(name)
                                }
                            }
                            
                            // 先跟文件夹名字对比，是否是文件夹的子内容
                            for directoryName in directoryNameArray {
                                // 如果文件夹数组不包含
                                if !directoryName .contains(name){
                                    // 没有就加入待定数组
                                    let mediaInfo = MediaInfo.init(name: name, url: url, isDirectory: isDirectory.boolValue)
                                    undeterminedInfoArray.append(mediaInfo)
                                }
                            }
                        }
                    }catch {
                        fatalError();
                    }
                }
            }
        }
        
        // 这一步返回的只是包含媒体名,跟媒体url路径的模型，后面还需根据播放时间筛
        if undeterminedInfoArray.count != 0 {
            for mediaInfo in undeterminedInfoArray{
                //线程间通信
                //                DispatchQueue.global().async {
                //                    let url = URL.init(string: mediaInfo.url);
                if mediaInfo.url.count > 0 {
                    // 如果是文件夹
                    if mediaInfo.isDirectory {
                        confirmArray.append(self.insertNewDataModel(mediaInfo: mediaInfo))
                        saveContext()
                    }else {
                        let media =  VLCMedia.init(path: mediaInfo.url)
                        media.lengthWait(until: Date(timeIntervalSinceNow: 2))
                        mediaInfo.media = media
                        let length = Double(mediaInfo.media.length.intValue) / 1000.0
                        if (length > 0) {
                            mediaInfo.length = Int(length)
                            confirmArray.append(self.insertNewDataModel(mediaInfo: mediaInfo))
                            saveContext()
                            
                        }
                    }
                }
            }
            
        }
        return confirmArray
    }
    
    
    
    // 插入数据
    func insertNewDataModel(mediaInfo: MediaInfo) -> MediaModel1 {
        let newModel = NSEntityDescription.insertNewObject(forEntityName: "MediaModel1", into: LD.context) as! MediaModel1
        newModel.name = mediaInfo.name
        newModel.url = mediaInfo.url
        newModel.isDirectory = mediaInfo.isDirectory
        saveContext()
        return newModel
    }
    
    // 删除数据数据
    func deleteData() {
        //        let fetchRequest: NSFetchRequest = Person.fetchRequest()
        //        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        //        do {
        //            let result = try context.fetch(fetchRequest)
        //            for person in result {
        //                context.delete(person)
        //            }
        //        } catch {
        //            fatalError();
        //        }
        //        saveContext()
    }
    
    // 更新更改数据
    func updateData(updateArray: [MediaModel1]) {
        for updateModel in updateArray {
            let fetchRequest: NSFetchRequest = MediaModel1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", updateModel.url! as CVarArg)
            do {
                let result = try LD.context.fetch(fetchRequest)
                
                if result.count != 0 {
                    let localModel = result.first!;
                    // 利用反射机制，遍历属性，将模型赋值
                    let mirror = Mirror(reflecting: localModel)
                    for case let (label?, _) in mirror.children {
                        localModel .setValue(localModel.value(forKey: label), forKey: label)
                    }
                }
            } catch {
                fatalError();
            }
        }
        saveContext()
    }
    
    // 查询数据数据
    func fetchMediaData(modelArray: [MediaModel1]) -> [MediaModel1] {
        var fetchArray = [MediaModel1]()
        // 根据Rom，mediaModel遍历数组
        for mediaModel in modelArray {
            // 根据URL取数据
            let fetchRequest: NSFetchRequest = MediaModel1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", mediaModel.url!)
            do {
                let result: [MediaModel1] = try LD.context.fetch(fetchRequest)
                if result.count != 0 {
                    fetchArray.append(result.first!)
                }
            } catch {
                fatalError()
            }
        }
        return fetchArray
    }
    
    
    // 保存数据
    func saveContext() {
        do {
            try LD.context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
}

