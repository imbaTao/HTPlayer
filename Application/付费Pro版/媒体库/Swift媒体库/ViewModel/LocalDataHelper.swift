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
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

func LDContext() -> NSManagedObjectContext {
   return LocalDataHelper.share.context
}


class LocalDataHelper {
    // 单利
    static let share = LocalDataHelper()
    
    // 上下文
    lazy var context: NSManagedObjectContext = {
         let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        return context
    }()
    
    // 初始化时创建数据库
    init() {
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
                }catch{
                    return
                }
            }
            
            else{
//                do {
//                    try FileManager.default.removeItem(at: documentDir.appendingPathComponent(".DataBase", isDirectory: false))
//                }catch{
//                    return
//                }
            }
            
         
            
            do {
                try store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: baseUrl, options: nil)
            } catch {}
            self.context.persistentStoreCoordinator = store
        }
    }
    
   
    
    /**
     1.文件要分层次的话，必须由根目录开始分文件夹遍历
     2.文件URL是动态不同的，但是规则是由homeDirectory + /                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               开辟的文件夹 + 文件名
     */
    
  // 获取文件名，拼接上根路径就是完整路径
   class func analyzeRomMediafiles() -> [MediaModel1] {
        //方法1
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)
        
        // 跟路径
        let documnetPath = documentPaths[0]
        
        // 文件管理
        let fileManager = FileManager.default;
        
        // 文件夹遍历
        let directoryEnum = fileManager.enumerator(atPath: documnetPath);
        
        // 本地确定有的媒体数组
        var confirmArray = [MediaModel1]();
    
        // 本地待定的媒体数组
        var undeterminedInfoArray = [MediaInfo]();
        if (directoryEnum != nil) {
            // 遍历根目录中所有文件
            for fileName in directoryEnum! {
                let name = fileName as! String
                let url = documnetPath + "/" + name
                // 如果包含特殊字符的过滤
                if url.contains("DataBase") || url.contains(".DS_Store") {
                    continue
                }
                
                // 创建获取请求
                let fetchRequest: NSFetchRequest = MediaModel1.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                do {
                    // 如果找到了就是唯一的
                    let result: [MediaModel1] = try LDContext().fetch(fetchRequest)
                    if result.count != 0 {// 如果有取出来
                        confirmArray.append(result.first!)
                    }else{ // 没有就加入待定数组
                        let mediaInfo = MediaInfo.init(name: name, url: url)
                        undeterminedInfoArray.append(mediaInfo)
                    }
                }catch {
                    fatalError();
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
                        let media =  VLCMedia.init(path: mediaInfo.url)
                        media.lengthWait(until: Date(timeIntervalSinceNow: 2))
                        mediaInfo.media = media
                        let length = Double(mediaInfo.media.length.intValue) / 1000.0
                        if (length > 0) {
                            //                            undeterminedInfoArray.remove(at: index
                            print(mediaInfo.media.length.value.intValue)
                            mediaInfo.length = Int(length)
                            confirmArray.append(self.insertNewDataModel(mediaInfo: mediaInfo))
                            saveContext()
                            
                        }
                }
            }
                    }
                    
//                    DispatchQueue.main.async {
//                        // 遍历出没有播放长度的media
//                        for(index,mediaInfo) in undeterminedInfoArray.enumerated(){
//
//                        }
                
                

//            }
//        }
        return confirmArray
    }
    
    
    // 插入数据
    class func insertNewDataModel(mediaInfo: MediaInfo) -> MediaModel1 {
        let newModel = NSEntityDescription.insertNewObject(forEntityName: "MediaModel1", into: LocalDataHelper.share.context) as! MediaModel1
        newModel.name = mediaInfo.name
        newModel.url = mediaInfo.url
        
        saveContext()
        return newModel
    }
    
    // 删除数据数据
    class func deleteData() {
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
    class func updateData(updateArray: [MediaModel1]) {
        for updateModel in updateArray {
            let fetchRequest: NSFetchRequest = MediaModel1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", updateModel.url! as CVarArg)
            do {
                let result = try LocalDataHelper.share.context.fetch(fetchRequest)
                
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
    class func fetchMediaData(modelArray: [MediaModel1]) -> [MediaModel1] {
        var fetchArray = [MediaModel1]()
        // 根据Rom，mediaModel遍历数组
        for mediaModel in modelArray {
            // 根据URL取数据
            let fetchRequest: NSFetchRequest = MediaModel1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", mediaModel.url!)
            do {
                let result: [MediaModel1] = try LocalDataHelper.share.context.fetch(fetchRequest)
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
    class func saveContext() {
        do {
            try LDContext().save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}




