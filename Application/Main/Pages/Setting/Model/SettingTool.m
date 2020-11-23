//
//  SettingTool.m
//  敢聊播放器
//
//  Created by Mr.h on 2018/9/17.
//  Copyright © 2018年 Great. All rights reserved.
//

#import "SettingTool.h"
#import "SettingStatusModel.h"
#import "DataHandleTool.h"
#import "ConfigManager.h"
@implementation SettingTool
+ (NSMutableArray *)takeTheSettingModel{
    //1.路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *contactPath = [doc stringByAppendingPathComponent:@".MediaInfo/S_info.arc"];
    NSMutableArray *modelArr = [DataHandleTool dataUnarchiveWithPath:contactPath];
    if (!modelArr.count) {
         modelArr = [NSMutableArray array];
         NSArray *nameArr;
        nameArr = @[LOCALKEY(@"Lock"),LOCALKEY(@"Feedback")];
        for (int i = 0; i < nameArr.count; ++i) {
            SettingStatusModel *model = [[SettingStatusModel alloc] init];
            model.titleName = nameArr[i];
            [modelArr addObject:model];
            switch (i) {
                case 0: model.buyed = true;break;
                case 1:{
                    if (HASLOCK) {
                        model.canUse = true;
                    }
                }break;
                case 2:{
                    model.canUse = true;
                }break;
                default:break;
            }
        }
      
        [SettingTool saveSettingModel:modelArr];
    }
    return modelArr;
}

+ (void)saveSettingModel:(NSMutableArray *)settingModelArray{
    //1.路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *contactPath = [doc stringByAppendingPathComponent:@".MediaInfo/S_info.arc"];
    [DataHandleTool dataArchiverWithData:settingModelArray withPath:contactPath];
}
@end
