//
//  SelectPhoneNumViewController.m
//  Demo
//
//  Created by LeeJay on 2017/3/27.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "SelectPhoneNumViewController.h"
#import "LJContactManager.h"

@interface SelectPhoneNumViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@end

@implementation SelectPhoneNumViewController

- (IBAction)selectPhoneNumAction:(id)sender
{
    [[LJContactManager sharedInstance] selectContactAtController:self complection:^(NSString *name, NSString *phone) {
        self.nameTextField.text = name;
        self.phoneNumTextField.text = phone;
    }];

}

@end
