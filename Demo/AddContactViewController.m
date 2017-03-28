//
//  AddContactViewController.m
//  Demo
//
//  Created by LeeJay on 2017/3/27.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "AddContactViewController.h"
#import "LJContactManager.h"

@interface AddContactViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *phoneNumBtn;

@end

@implementation AddContactViewController

- (IBAction)addContactAction:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"添加到通讯录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@"创建新联系人",@"添加到现有联系人", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[LJContactManager sharedInstance] createNewContactWithPhoneNum:self.phoneNumBtn.titleLabel.text controller:self];
    }
    else if (buttonIndex == 1)
    {
        [[LJContactManager sharedInstance] addToExistingContactsWithPhoneNum:self.phoneNumBtn.titleLabel.text controller:self];
    }
}

@end
