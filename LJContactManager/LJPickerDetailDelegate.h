//
//  LJPickerDetailDelegate.h
//  Demo
//
//  Created by LeeJay on 2017/4/24.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

@interface LJPickerDetailDelegate : NSObject <ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@property (nonatomic, copy) void (^handler) (NSString *name, NSString *phoneNum);

@end
