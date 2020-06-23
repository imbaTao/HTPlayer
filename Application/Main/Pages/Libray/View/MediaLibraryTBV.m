//
//  MediaPlayTBV.m
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/7/29.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaLibraryTBV.h"
#import "MediaViewCell.h"

@interface MediaLibraryTBV() <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>


@end


@implementation MediaLibraryTBV

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[MediaViewCell class] forCellReuseIdentifier:@"cell"];
        [self setSeparatorColor:[UIColor clearColor]];
        self.backgroundColor = RGB(74, 74, 74, 1);
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MediaModel *model = self.dataArr[indexPath.row];
//    model.indexPath = indexPath;
//    // 创建 NSMutableAttributedString
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.recordPlayTime];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                      value:RGB(25, 255, 31, 1) range:NSMakeRange(0, attrStr.length - 2)];
//    cell.playRecordTimeLB.attributedText = attrStr;
//    if (!cell.movieIconView.image) {
////        cell.movieIconView.image = model.thumbnail;
//    }
//    if (model.isSeleted) {
//        cell.circleImageView.image = [UIImage imageNamed:@"circleSelected"];
//    }else{
//        cell.circleImageView.image = [UIImage imageNamed:@"circleUnSelected"];
//    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self cellSeletedAction:indexPath];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action0 = [UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleNormal title:LOCALKEY(@"Rename") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        MediaViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        MediaModel *model  = nil;
//        cell.movieNameTV.userInteractionEnabled = true;
//        cell.movieNameTV.editable = true;;
//        [cell.movieNameTV becomeFirstResponder];
//
//        //获得文件的后缀名 （不带'.'）
//        NSString *suffixStr = [model.mediaName pathExtension];
//        cell.movieNameTV.text = model.mediaName;
//        UITextRange *range = cell.movieNameTV.selectedTextRange;
//        UITextPosition *start = [cell.movieNameTV positionFromPosition:range.start inDirection:UITextLayoutDirectionRight offset:suffixStr.length + 1];
//        if (start) {
//            [cell.movieNameTV setSelectedTextRange:[cell.movieNameTV textRangeFromPosition:start toPosition:start]];
//        }
        [self renameAction:@[@"",indexPath]];
    }];

    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LOCALKEY(@"Top") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self changeModelPlaceWith:indexPath destinationIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  
        [self moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
        });
    }];

    return @[action0,action1];
}

- (void)renameAction:(NSArray *)infoArr{
    
}

// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self changeModelPlaceWith:sourceIndexPath destinationIndexPath:destinationIndexPath];
}


// cell换位调用的方法
- (void)changeModelPlaceWith:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath{
    MediaModel  *sourceModel = self.dataArr[sourceIndexPath.row];
    [self.dataArr removeObject:sourceModel];
    [self.dataArr insertObject:sourceModel atIndex:destinationIndexPath.row];
    dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        int i = 1;
        for (MediaModel *model in self.dataArr) {
            model.rankNumber = i;
            i++;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [DBHelper updateMediaDataWithMediaName:self.dataArr];
        });
    });
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
      return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

#pragma mark - textfiledDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    textView.userInteractionEnabled = false;
    [self renameAction:@[textView.text]];
}

#pragma mark - Setter && Getter
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - Response
- (void)cellSeletedAction:(NSIndexPath *)indexPath{
    
}


@end
