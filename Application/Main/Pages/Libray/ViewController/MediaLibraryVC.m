//
//  MediaLibraryVC.m
//  myProgramming
//
//  Created by hong on 2017/4/27.
//  Copyright © 2017年 hong. All rights reserved.
//

#import "MediaLibraryVC.h"
#import "PlayerVC.h"
#import "LockerVC.h"
#import "MediaTool.h"
#import "HZYBubbleVC.h"
#import "MediaEditMenuBar.h"
#import "GuideVC.h"

#import <MessageUI/MessageUI.h>
#import "HZYReNameView.h"

#import "NSAttributedString+Colorful.h"
#import "MediaLibraryViewModel.h"


@interface MediaLibraryVC () <MediaCollectionViewDelegate,HZYBubbleDelegate,MediaEditMenuBarDelegate,HZYRenameViewDelegate,MediaLibraryNavTitleDelegate,UISearchBarDelegate,PlayerVCDelgate,MediaLibraryViewModelDelegate>

/** vm */
@property(nonatomic,strong)MediaLibraryViewModel *vm;

/** editMenuBar */
@property(nonatomic,strong)MediaEditMenuBar *editMenuBar;

/** UICollectionViewFlowLayout */
@property(nonatomic,strong)UICollectionViewFlowLayout  *cvLayout;

/** MenuBubble */
@property(nonatomic,strong)HZYBubbleVC *menuBubbleVC;

/** MediaInfoBubble */
@property(nonatomic,strong)HZYBubbleVC *mediaInfoBubble;

/** reNameView */
@property(nonatomic,strong)HZYReNameView *renameView;

/** noFilesImgView */
@property(nonatomic,strong)UIImageView *noFilesImgView;

/** currentMediaModel */
@property(nonatomic,strong)MediaModel *currentMediaModel;

/** 如果有字符串 再用过滤器展示有关信息 */
@property (nonatomic, copy) NSString *filterString;

/** 是否能旋转 */
@property(nonatomic,assign)BOOL canRotate;
@end


/** path */
#define currentPageNumberPath @"MediaModel/currentPageNumber"
#define INDEX(row) @[[NSIndexPath indexPathForRow:row inSection:0]]
@implementation MediaLibraryVC{
    CGFloat _bottomHeight;
}


#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = false;
    [self.navigationController setNavigationBarHidden:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([PlayerTool orientation] != UIInterfaceOrientationPortrait) {
        _canRotate = true;
        [PlayerTool orientationTo:UIInterfaceOrientationPortrait];
        _canRotate = false;
    }else{
        _canRotate = false;
    };
    
     [self interfaceConfig];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
           }];
           
           UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"注意,本产品只提供视频播放功能，不提供下载功能！" preferredStyle:UIAlertControllerStyleAlert];
           [ac addAction:okAction];
           [self presentViewController:ac animated:true completion:nil];
    });
}

- (void)checkDBVersion{
    
}

- (void)interfaceConfig{
    //    Arrange = true;
    //    [DBHelper removeDataBase];
    [self.vm initData];
#ifdef DEBUG
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]]);
#endif
    [self.view addSubview:self.libraryCollectionView];
    [self.view addSubview:self.editMenuBar];
    [self.view addSubview:self.navtitleView];
    [self.libraryCollectionView addSubview:self.noFilesImgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.renameView];
    [self layoutPageViews];
}

- (void)layoutPageViews{
    [_navtitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        if (@available(iOS 11.0, *)) {
            make.height.offset(64 + SAFE.top);
        } else {
           make.height.offset(64);
        }
    }];
    
    [_editMenuBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
             make.bottom.offset(-SAFE.bottom);
        } else {
              make.bottom.offset(0);
        }
        make.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(EditCellWidth * _editMenuBar.dataArray.count, EditCellHight));
    }];
    
    [_renameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_noFilesImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_libraryCollectionView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W * 0.4, SCREEN_W * 0.4));
    }];
    
    [_libraryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navtitleView.mas_bottom);
        make.left.offset(0);
        make.right.offset(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-(SAFE.bottom + 49));
        } else {
            make.bottom.offset(-49);
        }
    }];

}


#pragma mark - ViewModel代理时间
// 初始化数据完毕通知控制器刷新
- (void)initDataComplete{
   MEDIALIST = self.libraryCollectionView.dataArray = self.vm.mediaArray;
    HUD_Hide;
    [_libraryCollectionView reloadData];
    [_libraryCollectionView.mj_header endRefreshing];
    if (!_libraryCollectionView.dataArray.count) {
        self.noFilesImgView.hidden = false;
    }else{
        self.noFilesImgView.hidden = true;
    }
}

// 插入数据更新方法
- (void)newDataNeedRefresh:(MediaModel *)infoModel{
    if ([self p_isCurrentViewControllerVisible:self]) {
        [_libraryCollectionView insertItemsAtIndexPaths:INDEX(infoModel.rankNumber - 1)];
    }else{
        [_libraryCollectionView reloadData];
    }
    _noFilesImgView.hidden = true;
}

#pragma mark - 导航栏功能
- (void)naviButtonActionWithType:(NSInteger)type{
    switch (type) {
        case 0:{// 查询
            _navtitleView.searchButtonLeftConstraint.constant = -44;
            _navtitleView.menuButtonRightConstraint.constant = -44;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
                _navtitleView.searchBar.alpha = 1;
            }completion:^(BOOL finished) {
                [_navtitleView.searchBar becomeFirstResponder];
            }];
        }break;
        case 1:{// 显示气泡
            [self.menuBubbleVC showBubbleWithVC:self];
        }break;
        default:break;
    }
}

#pragma mark - 气泡菜单（两个气泡菜单，右上角，和长按信息）
- (void)bubbleCellSelected:(NSInteger)row type:(BubbleTye)type{
    switch (type) {
        case MenuBubble:{
            switch (row) {
                case 0:{// 编辑模式
                     self.libraryCollectionView.isEditing = !self.libraryCollectionView.isEditing;
                    if (self.libraryCollectionView.isEditing) {
                          [[HZYTabbarController share] hiddeTabbar];
                         [self.editMenuBar showOrHiddenBar:true];
                    }else{
                        [self p_completEdit];
                    }
                    [self.menuBubbleVC hideBubble];
                }break;
                case 1:{// 使用说明
//                    [self.menuBubbleVC hideBubble];
//                    GuideVC *infoVC = [[GuideVC alloc] init];
//                    [self presentViewController:infoVC animated:YES completion:nil];
                }break;
            }
        }break;
        case InfomationBubble:{// 长按气泡
            [self.mediaInfoBubble hideBubble];
            switch (row) {
                case 0:{ // 播放
                    PlayerVC *playVC = [[PlayerVC alloc] initWithMediaDataArray:[NSMutableArray arrayWithArray:@[_currentMediaModel]]];
                    playVC.delegate = self;
                    playVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self.navigationController presentViewController:playVC animated:true completion:^{
                        [playVC startPlayWithIndex:row];
                    }];
                }break;
                case 1:{// 重命名
                    [self.renameView showWithSourceName:_currentMediaModel.mediaName];
                }break;
                case 2:{// 删除
                    [self checkDeleteFile:[NSMutableArray arrayWithObject:_currentMediaModel]];
                }break;
            }
        }break;
    }
}

#pragma mark -  编辑栏事件
- (void)menuSeletedWithIndexRow:(NSInteger)row{
    switch (row) {
        case 0:{// 全选
            int selectedCount = 0;
          MediaEditMenuModel *editModel = _editMenuBar.dataArray[0];
            for (MediaModel *mediaModel in MEDIALIST) {
                mediaModel.isSeleted = editModel.isSeleted;
                if (mediaModel.isSeleted) {
                    selectedCount++;
                }
            }
            _libraryCollectionView.selectedCount = selectedCount;
            [_libraryCollectionView reloadData];
            [self p_checkEditBarStatus];
        }break;
        case 1:{// 置顶
            [self p_topAction];
        }break;
        case 2:{// 播放选中内容
            [self p_playGroup];
        }break;
        case 3:{// 重命名
            [self p_rename];
        }break;
        case 4:{ // 删除
            [self p_delete];
        }break;
        case 5:{// 完成
            [self p_completEdit];
        }break;
        default:break;
    }
}

#pragma mark - 完成编辑
- (void)p_completEdit{
    // 如果编辑选中过
    if (_libraryCollectionView.selectedCount) {
        for (int i = 0; i < _libraryCollectionView.dataArray.count; i++) {
            MediaModel *model = _libraryCollectionView.dataArray[i];
            model.rankNumber = i + 1;
        }
        [DBHelper updateMediaDataWithMediaName:_libraryCollectionView.dataArray];
        [_libraryCollectionView p_endEdit];
        [UIView animateWithDuration:0 animations:^{
            [_libraryCollectionView performBatchUpdates:^{
                [_libraryCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            } completion:nil];
        }];
    }
    _libraryCollectionView.isEditing = false;
    [[HZYTabbarController share] showTabbar];
    [_editMenuBar showOrHiddenBar:false];
}

#pragma mark - 置顶
- (void)p_topAction{
    int passCount = 0;
    for (long i = 0; i < self.libraryCollectionView.dataArray.count ; i++) {
        MediaModel *model = self.libraryCollectionView.dataArray[i];
        if (model.isSeleted) {
            [self.libraryCollectionView.dataArray removeObjectAtIndex:i];
            [self.libraryCollectionView.dataArray insertObject:model atIndex:passCount];
            [self.libraryCollectionView moveItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] toIndexPath:[NSIndexPath indexPathForRow:passCount inSection:0]];
            passCount++;
        }
    }
}

#pragma mark - 组播放
- (void)p_playGroup{
    NSMutableArray *needPlayArray = [NSMutableArray array];
    for (int i = 0; i < self.libraryCollectionView.dataArray.count; i++) {
        MediaModel *model = self.libraryCollectionView.dataArray[i];
        if (model.isSeleted) {
            [needPlayArray addObject:model];
        }
    }
    

    PlayerVC *playVC = [[PlayerVC alloc] initWithMediaDataArray:needPlayArray];
    playVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:playVC animated:true completion:^{
        [playVC startPlayWithIndex:0];
    }];

    // 传给播放器
}

#pragma mark - 重命名
- (void)p_rename{
    for (int i = 0; i < self.libraryCollectionView.dataArray.count; i++) {
        MediaModel *model = self.libraryCollectionView.dataArray[i];
        if (model.isSeleted) {
            _currentMediaModel = model;
            [self.renameView showWithSourceName:model.mediaName];
            break;
        }
    }
}

#pragma mark - 完成重命名回调
- (void)finishChangeFileName:(NSString *)fileName{
    // 如果没有重名
      [self.renameView.changeTitleTF resignFirstResponder];
    if (![MediaTool checkHaveSameNameWithNewName:[NSString stringWithFormat:@"%@.%@",fileName,[_currentMediaModel.mediaName pathExtension]]]) {
        NSFileManager * manager = [NSFileManager defaultManager];
        NSString *doucumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePacketPath = [NSString stringWithFormat:@"%@/%@",doucumentPath,_currentMediaModel.mediaName];
        
        _currentMediaModel.mediaName = [NSString stringWithFormat:@"%@.%@",fileName,[_currentMediaModel.mediaName pathExtension]];
        NSString *newPath = [NSString stringWithFormat:@"%@/%@",doucumentPath,_currentMediaModel.mediaName];
        _currentMediaModel.mediaURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],_currentMediaModel.mediaName]];
        _vm.isRenaming = true;
        [manager moveItemAtPath:filePacketPath toPath:newPath error:nil];
        [DBHelper updateMediaDataWithRankNumber:[NSMutableArray arrayWithObject:_currentMediaModel]];
        [_renameView hid];
        [_libraryCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentMediaModel.rankNumber - 1 inSection:0]]];
    }else{
        [_renameView hid];
        __weak typeof(self)weakself = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.renameView.changeTitleTF becomeFirstResponder];
            [weakself.renameView showWithSourceName:weakself.currentMediaModel.mediaName];
        }];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:LOCALKEY(@"Warning") message:LOCALKEY(@"RenameTips") preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:true completion:nil];
    }
}

#pragma mark - 删除
- (void)p_delete{
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (int i = 0; i < self.libraryCollectionView.dataArray.count; i++) {
        MediaModel *model = self.libraryCollectionView.dataArray[i];
        if (model.isSeleted) {
            [deleteArr addObject:model];
        }
    }
    
    if (deleteArr.count > 1) {
        __weak typeof (self)weakSelf = self;
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf checkDeleteFile:deleteArr];
        }];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:LOCALKEY(@"Warning") message:LOCALKEY(@"deletTips") preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:okAction];
        [alertC addAction:cancleAction];
        [self presentViewController:alertC animated:true completion:nil];
    }else{
        [self checkDeleteFile:deleteArr];
    }
}

// 检测删除文件
- (void)checkDeleteFile:(NSMutableArray *)mediaArray{
    NSMutableArray *indexArr =  [MediaTool deleteMovieFileWithMediaModelArr:mediaArray];
    if (indexArr.count) {
        HUD_Loading;
        [DBHelper updateMediaDataWithMediaName:MEDIALIST];
        _libraryCollectionView.selectedCount = 0;
        _currentMediaModel = nil;
        [self p_checkEditBarStatus];
    }else{
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"存在异常文件,无法删除,请使用电脑手动删除!" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:true completion:nil];
    }
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    if (KIsiPhoneX) {
//        if (@available(iOS 11.0, *)) {
//            [_libraryCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.offset(StatusBarHeight);
//                make.left.offset(SAFE.left);
//                make.right.offset(-SAFE.right);
//                if (!NoAD) {
//                    make.bottom.mas_equalTo(self.bannerView.mas_top);
//                }else{
//                    make.bottom.mas_equalTo(-SAFE.bottom);
//                }
//            }];
//        }
//    }
}



#pragma mark - 媒体Cell选中
- (void)cellselectedWithRow:(NSInteger)row isEditing:(BOOL)isEditing{
    if (!isEditing) {
        PlayerVC *playVC = [[PlayerVC alloc] initWithMediaDataArray:MEDIALIST];
        playVC.delegate = self;
        [self.navigationController presentViewController:playVC animated:true completion:^{
            [playVC startPlayWithIndex:row];
        }];
    }else{
        // 检测BarView上按钮是否可以点击
        [self p_checkEditBarStatus];
    }
}


#pragma mark - 查看视频信息
- (void)checkOutMediaInfo:(BOOL)beginOrEnd indexRow:(NSInteger)row{
    if (beginOrEnd) {
        _currentMediaModel = self.libraryCollectionView.dataArray[row];
      [self.mediaInfoBubble showBubbleWithVC:self];
        _mediaInfoBubble.headerView.titleLB.text  = _currentMediaModel.mediaName;
        NSArray *trackInfoArr = _currentMediaModel.media.tracksInformation;
        CGFloat width = 0;
        CGFloat height = 0;
        NSString *ratioStr = @"00 · 00";
        if (trackInfoArr.count) {
            width = [[trackInfoArr[0] objectForKey:@"width"] floatValue];
            height = [[trackInfoArr[0] objectForKey:@"height"] floatValue];
            ratioStr = [NSString stringWithFormat:@" %.0f · %.0f",width,height];
        }

        NSString *subTitleText = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",[NSString stringWithFormat:@"%@ / %@",_currentMediaModel.recordPlayTime,_currentMediaModel.allPlayTime],ratioStr,_currentMediaModel.mediaSize,[_currentMediaModel.mediaName pathExtension]];
        _mediaInfoBubble.headerView.playTimeLB.attributedText = [NSAttributedString ColorFulStringWithString:subTitleText lengthArray:@[@8] colorArray:@[RGB(74, 144, 226, 1)] allColor:[UIColor whiteColor]];
    }
}

#pragma mark - 从播放控制器返回刷新缩略图
- (void)backActionRefreshThumbnail{
    if ([_libraryCollectionView.dataArray containsObject:Playing]) {
        [_libraryCollectionView reloadItemsAtIndexPaths:INDEX(Playing.rankNumber - 1)];
        [DBHelper updateMediaDataWithMediaName:[NSMutableArray arrayWithObject:Playing]];
    }
}

#pragma mark - 搜索影片功能代理
//点击键盘上的search按钮时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.filterString = @"";
    _navtitleView.searchBar.text = @"";
    [searchBar resignFirstResponder];
}


//输入文本实时更新时调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.filterString = searchText;
}

//cancel按钮点击时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _navtitleView.searchBar.text = self.filterString = @"";
    _libraryCollectionView.dataArray = MEDIALIST;
    _navtitleView.searchButtonLeftConstraint.constant = 12;
    _navtitleView.menuButtonRightConstraint.constant = 12;
    [_navtitleView.searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _navtitleView.searchBar.alpha = 0;
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    return  true;
}

#pragma mark - setter&getter
- (MediaLibraryViewModel *)vm{
    if (!_vm) {
        _vm = [[MediaLibraryViewModel alloc] init];
        _vm.delegate = self;
    }
    return _vm;
}

- (MediaLibraryNavTitleView *)navtitleView{
    if (!_navtitleView) {
        _navtitleView = [[NSBundle mainBundle] loadNibNamed:@"MediaLibraryNavTitleView" owner:nil options:nil].lastObject;
        _navtitleView.searchBar.delegate = self;
        _navtitleView.delegate = self;
    }
    return _navtitleView;
}

- (UIImageView *)noFilesImgView{
    if (!_noFilesImgView) {
        _noFilesImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MediaLibaray_NoFiles"]];
        _noFilesImgView.hidden = true;
        _noFilesImgView.alpha = 0.3;
    }
    return _noFilesImgView;
}
- (LibraryCollectionView *)libraryCollectionView{
    if (!_libraryCollectionView) {
        _cvLayout = [[UICollectionViewFlowLayout alloc] init];
        _cvLayout.minimumLineSpacing = 8;
        _cvLayout.minimumInteritemSpacing = 8;
        _cvLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cvLayout.itemSize = CGSizeMake(MediaCellWidth, MediaCellWidth * 1.3333 + 30);
        if (IS_PAD) {
            _cvLayout.itemSize = CGSizeMake(MediaCellWidth, MediaCellWidth * 1.3333 + 60);
        }
        //创建一个layout布局类
        _libraryCollectionView = [[LibraryCollectionView alloc] initWithLayout:_cvLayout cellClass:[MediaViewCell class] identifier:@"pageCell"];
         _libraryCollectionView.showsVerticalScrollIndicator = false;
        _libraryCollectionView.cellDelegate = self;
        _libraryCollectionView.backgroundColor = StyleColor;
        _libraryCollectionView.clipsToBounds = false;
        _libraryCollectionView.layer.masksToBounds = false;
        __weak typeof(self)weakself = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself.vm initData];
        }];
        
//        header.ignoredScrollViewContentInsetTop = 150;
        _libraryCollectionView.mj_header = header;
    }
    return _libraryCollectionView;
}

- (HZYBubbleVC *)menuBubbleVC{
    if (!_menuBubbleVC) {
//        _menuBubbleVC = [[HZYBubbleVC alloc] initWithTitleArr:@[@"编辑模式",@"显示方式",@"使用说明"] picNameArr:@[@"Bubble_Edit",@"Bubble_ViewOption",@"Bubble_Explain"] appointView:_navtitleView.menuButton width:SCREEN_W * 0.3 haveHeader:false];
//        _menuBubbleVC = [[HZYBubbleVC alloc] initWithTitleArr:@[LOCALKEY(@"Edit"),LOCALKEY(@"Instructions")] picNameArr:@[@"Bubble_Edit",@"Bubble_Explain"] appointView:_navtitleView.menuButton width:SCREEN_W * 0.3 haveHeader:false];
        
         _menuBubbleVC = [[HZYBubbleVC alloc] initWithTitleArr:@[LOCALKEY(@"Edit")] picNameArr:@[@"Bubble_Edit"] appointView:_navtitleView.menuButton width:SCREEN_W * 0.3 haveHeader:false];
        _menuBubbleVC.delegate = self;
    }
    return _menuBubbleVC;
}

- (HZYBubbleVC *)mediaInfoBubble{
    if (!_mediaInfoBubble) {
        _mediaInfoBubble = [[HZYBubbleVC alloc] initWithTitleArr:@[LOCALKEY(@"Play"),LOCALKEY(@"Rename"),LOCALKEY(@"delete")] picNameArr:@[@"Bubble_Play",@"Bubble_Rename",@"Bubble_Delete"] appointView:self.view width:SCREEN_W * 0.9 haveHeader:true];
        _mediaInfoBubble.delegate = self;
    }
    return _mediaInfoBubble;
}


- (HZYReNameView *)renameView{
    if (!_renameView) {
        _renameView = [[NSBundle mainBundle] loadNibNamed:@"HZYReNameView" owner:nil options:nil].lastObject;
        _renameView.delegate = self;
    }
    return _renameView;
}
- (MediaEditMenuBar *)editMenuBar{
    if (!_editMenuBar) {
       UICollectionViewFlowLayout *cvLayout = [[UICollectionViewFlowLayout alloc] init];
        cvLayout.minimumLineSpacing = 0;
        cvLayout.minimumInteritemSpacing = 0;
        cvLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        cvLayout.itemSize =  CGSizeMake(EditCellWidth, EditCellHight);
        //创建一个layout布局类
        _editMenuBar = [[MediaEditMenuBar alloc] initWithLayout:cvLayout cellClass:[MediaEditMenuCell class] identifier:@"editCell"];
        _editMenuBar.showsVerticalScrollIndicator = false;
        _editMenuBar.scrollEnabled = false;
        _editMenuBar.cellDelegate = self;
        _editMenuBar.backgroundColor = [UIColor clearColor];
        _editMenuBar.clipsToBounds = false;
        _editMenuBar.layer.masksToBounds = false;
        _editMenuBar.backgroundColor =  StyleColor;
        _editMenuBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _editMenuBar.layer.shadowOpacity = 0.8;
        _editMenuBar.layer.shadowOffset = CGSizeMake(0, 2);
        _editMenuBar.layer.shadowRadius = 4.0;
        _editMenuBar.layer.cornerRadius = 8;
    }
    return _editMenuBar;
}



- (void)setFilterString:(NSString *)filterString {
    filterString = filterString;
    if (filterString && filterString.length > 0) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", filterString];
        NSArray *tempNameArr =  [self.vm.db_allNameArr filteredArrayUsingPredicate:filterPredicate];
        NSMutableArray *tempFilterArr = [NSMutableArray array];
        for (NSString *name in tempNameArr) {
            for (MediaModel *temp in MEDIALIST) {
                if ([temp.mediaName containsString:name]) {
                    [tempFilterArr addObject:temp];
                    break;
                }
            }
        }
        _libraryCollectionView.dataArray = tempFilterArr;
    }else{
        _libraryCollectionView.dataArray = MEDIALIST;
    }
    [_libraryCollectionView reloadData];
}


#pragma mark - 检测编辑栏的菜单状态
- (void)p_checkEditBarStatus{
    for (int i = 0; i < _editMenuBar.dataArray.count; i++) {
        MediaEditMenuModel *model = _editMenuBar.dataArray[i];
        model.canUse = true;
        if (_libraryCollectionView.selectedCount > 1) {
            if (i == 3) {
                model.canUse = false;
            }
        }else if(_libraryCollectionView.selectedCount == 0){
               model.canUse = false;
        }
    }
    
    [UIView animateWithDuration:0 animations:^{
        [_editMenuBar performBatchUpdates:^{
            [_editMenuBar reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
    }];
  
}

- (BOOL)shouldAutorotate {
    return _canRotate;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(BOOL)p_isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
