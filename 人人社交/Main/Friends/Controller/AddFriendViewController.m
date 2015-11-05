//
//  AddFriendViewController.m
//  人人社交
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AVQuery.h"
#import "AVUser+Avatar.h"
#import "FriendsViewController.h"
#import "AVOSCloud.h"
@interface AddFriendViewController ()
{
    
    UIAlertView *_alert;
}
@property (strong, nonatomic) IBOutlet UITextField *addFriendTextField;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation AddFriendViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        _friends = [[NSMutableArray alloc]init];
        _fiiendsDicArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"添加好友";
        
        
    }
    return self;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _addFriendTextField.placeholder = @"好友id";
    [_addButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated {
    _addFriendTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)add:(UIButton *)sender {
    
//    AVQuery *query = [AVQuery queryWithClassName:@"User"];
//    [query setCachePolicy:kAVCachePolicyNetworkElseCache];
//    [query whereKey:@"username" containsString:_addFriendTextField.text];
//    AVUser *curUser = [AVUser currentUser];
//    [query whereKey:@"objectId" notEqualTo:curUser.objectId];
//    [query orderByDescending:@"updatedAt"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error) {
//            NSLog(@"%@",[error description]);
//        }
//        NSLog(@"%@",objects);
//    }];
    
    //假数据加好友
    
    if (_addFriendTextField.text.length > 0) {

        for (NSString *firendId in _friends) {
            
            if ([_addFriendTextField.text isEqualToString:firendId]) {
                if (_alert == nil) {
                    _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"好友已经加了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                }
                    [_alert show];
                    return;
            }
        }
        
        AVObject *_friendsList = [AVObject objectWithClassName:@"FriendsList"];
        [_friendsList setObject:_addFriendTextField.text forKey:@"friendsId"];
        [_friendsList save];
        
         NSDictionary *firendDic = @{@"friendsId":_addFriendTextField.text};
        [_fiiendsDicArray addObject:firendDic];
        _addFriendTextField.text = nil;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
   
}



@end
