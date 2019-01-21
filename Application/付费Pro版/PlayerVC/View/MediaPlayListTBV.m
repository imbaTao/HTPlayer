//
//  MediaPlayTBV.m
//  TinyPlayer_V1
//
//  Created by Buddy.H on 2017/7/29.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaPlayListTBV.h"
#import "MediaPlayCell.h"
#import "PlayerVC.h"
#import "MediaModel.h"
#import "MediaTool.h"

@interface MediaPlayListTBV() <UITableViewDelegate,UITableViewDataSource>



@end

@implementation MediaPlayListTBV

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[MediaPlayCell class] forCellReuseIdentifier:@"cell"];
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 74;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        [self setSeparatorColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MediaModel *infoModel  = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mediaNameLB.text = [NSString stringWithFormat:@"%zd. %@",indexPath.row + 1,infoModel.mediaName];
    if (infoModel == Playing) {
        cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self playInlistWithIndex:indexPath];
}

- (void)playInlistWithIndex:(NSIndexPath *)indexPath{

}
@end
