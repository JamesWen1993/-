//
//  FriendsViewController.m
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsTableView.h"
#import "AVQuery.h"
#import "FriendsModel.h"
#import "AddFriendViewController.h"
#import "UIViewExt.h"
#import "CDChatManager.h"
#import "LCEChatRoomVC.h"
#import "pinyin.h"


@interface FriendsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    FriendsTableView *_tableView;
    UIButton *_rightButton;
    UISearchBar *_searchBar;
    UIView *_bgView;
    NSMutableArray *_words;//拷贝数组
    NSMutableArray *_keys;//拷贝的所有key
    UITableView *_searchTable;//搜索table
    AddFriendViewController *add;
    NSMutableArray *friendsIdArray;
    UIImageView *_imageView;
}

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"好友";
    [self _createAnimat];
    [self _creatSearchBar];
    [self _creatTable];
    [self _creatAddFriend];


}
- (void)viewWillAppear:(BOOL)animated {
    if (add.fiiendsDicArray != nil ) {
        _friends = add.fiiendsDicArray;
        _tableView.userSectionArray = [UserTableSection createWithSourceArray:_friends];
    }
    [_tableView reloadData];
}


#pragma mark - 创建加载动画
- (void)_createAnimat
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-20, 100, 40, 40)];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i < 5; i++) {
            NSString *string = [NSString stringWithFormat:@"refresh0%i@2x",i];
            UIImage *image = [UIImage imageNamed:string];
            [imageArray addObject:image];
        }
        
        //图片视图的动画数组
        _imageView.animationImages = imageArray;
        _imageView.animationDuration = 0.5;
        
        //启动动画
        [_imageView startAnimating];
        
        [self.view addSubview:_imageView];
    }
}

- (void)_creatSearchBar {
    if (_searchBar == nil) {
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索好友";
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
        [self.view addSubview:_searchBar];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-40)];
        _bgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _bgView.hidden = YES;
        
        
        UITapGestureRecognizer *tap =    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewIdentity)];
        tap.delegate = self;
        [_bgView addGestureRecognizer:tap];
        
        
        [self.view addSubview:_bgView];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(100, 40, kScreenWidth-200, kScreenWidth-200)];
        image.image = [UIImage imageNamed:@"channel_baoliao_avata@2x"];
        [_bgView addSubview:image];
        
        _searchTable = [[UITableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-10, 375)];
        _searchTable.backgroundColor = [UIColor clearColor];
        _searchTable.delegate = self;
        _searchTable.dataSource = self;
        _searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_bgView addSubview:_searchTable];
    }
    
}

//屏蔽点击
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (_searchTable.visibleCells.count ==0) {
        return YES;
    }
    
    
    return NO;

}



//搜索
- (void)resetSearch{
    _words = [_friendsID mutableCopy];//得到所有字典的副本 得到一个字典
    _keys = [[NSMutableArray alloc]init];
    _keys = [_words mutableCopy];
}
//实现搜索方法
- (void)handleSearchForTerm:(NSString *)searchTerm {
    [self resetSearch];
    
    for(NSString *key in _words) //实现搜索
    {
        NSString *keyWords = key;
        NSMutableString * _hanzi= [NSMutableString string];
        //汉子取每个字的首字母
        for (NSUInteger i = 0; i < key.length; i ++) {
            unichar aChar = [key characterAtIndex:i];
            if (isFirstLetterHANZI(aChar)) {
                unichar pinyinChar = pinyinFirstLetter(aChar);
                
                [_hanzi appendString:[NSString stringWithFormat:@"%c", pinyinChar]];
                
            }
        }
        if (_hanzi.length > 0) {
            keyWords = _hanzi;
        }
        NSLog(@"%@",_hanzi);
        
        if([keyWords rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound){//搜索时忽略大小写 把没有搜到的值 放到要删除的对象数组中去
            
            [_keys removeObject:key]; //把没有搜到的内容删掉
            
        }
    }
    
    [_searchTable reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        
        [self handleSearchForTerm:searchText];
    }
    if (searchText.length == 0) {
        [_keys removeAllObjects];
        [_searchTable reloadData];

    }
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:.3 animations:^{
        searchBar.showsCancelButton = YES;
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -64);
        _searchBar.transform = CGAffineTransformMakeTranslation(0, -30);
        _bgView.hidden = NO;
    }];
    
    _tableView.hidden = YES;
    [searchBar resignFirstResponder];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    _searchBar.showsCancelButton = NO;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.text = nil;
    [UIView animateWithDuration:.3 animations:^{
        _searchBar.showsCancelButton = NO;
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        _searchBar.transform = CGAffineTransformIdentity;
        _bgView.hidden = YES;
    }];
    _tableView.hidden = NO;
    [_keys removeAllObjects];
    [searchBar resignFirstResponder];
    [_searchTable reloadData];
}
- (void)viewIdentity {
    _searchBar.text = nil;
    [UIView animateWithDuration:.5 animations:^{
        _searchBar.showsCancelButton = NO;
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        _searchBar.transform = CGAffineTransformIdentity;
        _bgView.hidden = YES;
    }];
    _tableView.hidden = NO;
    [_keys removeAllObjects];
    [_searchBar resignFirstResponder];
    [_searchTable reloadData];
}

- (void)_creatAddFriend {
    //右侧按钮创建
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-45, 0, 44, 44)];
    [_rightButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;

}

- (void)addFriend {
    
    [self.navigationController pushViewController:add animated:YES];
    
}

- (void)_creatTable {
    
    _friends = [[NSMutableArray alloc]init];

    _tableView = [[FriendsTableView alloc]initWithFrame:CGRectMake(0, 64+30, kScreenWidth, kScreenHeight-64-30-49) style:UITableViewStylePlain];

    [self.view addSubview:_tableView];
    _friendsID = [[NSMutableArray alloc]init];
    friendsIdArray = [[NSMutableArray alloc]init];
    [self _findFriends];
}
    //查找好友列表
- (void)_findFriends {

    AVQuery *query = [AVQuery queryWithClassName:@"FriendsList"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@",objects);
        NSDictionary *localData = [objects valueForKey:@"localData"];
        
        for (NSDictionary *friendsDic in localData) {
            
            NSString *friendsId = [friendsDic objectForKey:@"friendsId"];
            if (friendsId != nil) {
                
                FriendsModel *model = [[FriendsModel alloc] initWithDataDic:friendsDic];
                [friendsIdArray addObject:model];
                
                [_friends addObject:friendsDic];
                [_friendsID addObject:friendsId];
            }
        }
        // 获取列表数据源
        _tableView.userSectionArray = [UserTableSection createWithSourceArray:_friends];
        _tableView.friendsDataArray = friendsIdArray;
        [_imageView stopAnimating];
        [_tableView reloadData];
        
        //添加好友里的好友id
        add = [[AddFriendViewController alloc]init];
        add.friends = _friendsID;
        add.fiiendsDicArray = _friends;
    }];

}


#pragma mark -tabelDeleage

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_keys count] == 0)
    {
        return 0;
    }

    return _keys.count; //返回元素的个数
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NoteSectionIdentifier = @"NoteSectionIdentifier";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NoteSectionIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoteSectionIdentifier];
        
    }
    cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    cell.textLabel.text = _keys[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *otherId = _keys[indexPath.row];
    WEAKSELF
    [[CDChatManager manager] fetchConvWithOtherId:otherId callback:^(AVIMConversation *conversation, NSError *error) {
        if (error) {
            DLog(@"%@", error);
        }
        else {
            LCEChatRoomVC *chatVc = [[LCEChatRoomVC alloc]initWithConv:conversation];
            chatVc.title = otherId;
            chatVc.hidesBottomBarWhenPushed = YES;
            _searchBar.text = nil;
            _searchBar.showsCancelButton = NO;
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
            _searchBar.transform = CGAffineTransformIdentity;
            _bgView.hidden = YES;
            _tableView.hidden = NO;
            [_keys removeAllObjects];
            [_searchBar resignFirstResponder];
            [_searchTable reloadData];
            [weakSelf.navigationController pushViewController:chatVc animated:YES];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
