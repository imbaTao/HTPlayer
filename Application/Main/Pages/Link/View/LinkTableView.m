//
//  LinkTableView.m
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "LinkTableView.h"
#import "LinkTableViewCell.h"
#import "LinkGuideCell.h"
#import "SJXCSMIPHelper.h"
@interface LinkTableView()<GCDWebUploaderDelegate>

@end

@implementation LinkTableView
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellID];
    cell.backGroundImgView.image = [UIImage imageNamed:@"discover_blackBoard"];
    cell.explainTextView.text = [self takeTipsArrayWithIndexPath:indexPath];
    if (!indexPath.section) {
        cell.guideImgView.image = [UIImage imageNamed:@"discover_itunes"];
    }else{
        cell.isSecondCell = true;
        cell.guideImgView.image = [UIImage imageNamed:@"discover_wifi"];
    }
    return cell;
}

- (NSString *)takeTipsArrayWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tipsArr = [NSMutableArray array];
    NSString *finalStr;
    for (int i = 0; i < 4; i++) {
        NSString *localKey = [NSString stringWithFormat:@"Connect%ld",indexPath.section * 5 + i + 1];
        NSString *tipStr = [NSString stringWithFormat:@"%d.%@",i+1,LOCALKEY(localKey)];
         if (indexPath.section == 0 && i == 3) {
             NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
             NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
             if (appCurName.length) {
                 tipStr = [tipStr stringByReplacingOccurrencesOfString:@"%@" withString:appCurName];
             }else{
                 tipStr = [tipStr stringByReplacingOccurrencesOfString:@"%@" withString:@"WhatsPlayer"];
             }
         }else if (indexPath.section == 1 && i == 1){
              tipStr =  [tipStr stringByReplacingOccurrencesOfString:@"%@" withString:[self demo_wifiTransfer]];
         }
        
        if (!finalStr.length) {
                 finalStr = @"";
        }
        finalStr = [NSString stringWithFormat:@"%@%@\n\n",finalStr,tipStr];
    }
    return finalStr;
}


#pragma mark - WifiTransfer
- (NSString *)demo_wifiTransfer{
    // 文件存储位置
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSLog(@"文件存储位置 : %@", documentsPath);
    // 创建webServer，设置根目录
    _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    // 设置代理
    _webServer.delegate = self;
    _webServer.allowHiddenItems = YES;
    // 限制文件上传类型
//    _webServer.allowedFileExtensions = @[@"doc", @"docx", @"xls", @"xlsx", @"txt", @"pdf"];
    // 设置网页标题
    _webServer.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!_webServer.title.length) {
        _webServer.title = @"";
    }
    // 设置展示在网页上的文字(开场白)
//    _webServer.prologue = @"";
    // 设置展示在网页上的文字(收场白)
//    _webServer.epilogue = @"";
    if ([_webServer start]) {
        return [NSString stringWithFormat:@"%@",[SJXCSMIPHelper deviceIPAdress]];
    } else {
        NSString *str =  NSLocalizedString(@"GCDWebServer not running!",nil);
        return str;
//        showIpLabel.text = NSLocalizedString(@"GCDWebServer not running!", nil);
//        return @"xxxx";
    }
}

- (void)closeServer{
    [_webServer stop];
    _webServer = nil;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return top(40);
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W,15)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        titleLable.text = LOCALKEY(@"FirstWay");
        return titleLable;
    }else{
        titleLable.text = LOCALKEY(@"SecondWay");
    }
    return titleLable;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section) {
        return bottom(49 + 15);
    }else{
        return bottom(15);
    }
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end






