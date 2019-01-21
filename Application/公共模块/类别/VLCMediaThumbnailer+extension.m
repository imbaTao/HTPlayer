//
//  MonitorFileChangeUtils+one.m
//  HZYToolBox
//
//  Created by hong  on 2018/9/10.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <objc/runtime.h>
#import "VLCMediaThumbnailer+extension.h"

@implementation VLCMediaThumbnailer (extension)
//定义常量 必须是C语言字符串
static char *modelKey = "modelKey";
-(void)setModel:(MediaModel *)model{
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, modelKey,model, OBJC_ASSOCIATION_ASSIGN);
}

-(MediaModel *)model{
    return objc_getAssociatedObject(self,modelKey);
}

@end
