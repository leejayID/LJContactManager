//
//  AddressBookViewController.m
//  Demo
//
//  Created by LeeJay on 2017/3/24.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "AddressBookViewController.h"
#import "LJContactManager.h"
#import "LJPerson.h"

@interface AddressBookViewController ()

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[LJContactManager sharedInstance] accessContactsComplection:^(BOOL succeed, NSArray *datas) {
        
        self.dataSource = datas;
        [self.tableView reloadData];
        
        for (LJPerson *person in datas)
        {
            NSLog(@"名字列表：fullName = %@, firstName = %@, lastName = %@", person.fullName, person.familyName, person.givenName);
            
            for (LJPhone *model in person.phones)
            {
                NSLog(@"号码：phone = %@, label = %@", model.phone,model.label);
            }
            
            for (LJEmail *model in person.emails)
            {
                NSLog(@"电子邮件：email = %@, label = %@", model.email, model.label);
            }
            
            for (LJAddress *model in person.addresses)
            {
                NSLog(@"地址：address = %@, label = %@", model.city, model.label);
            }
            for (LJMessage *model in person.messages)
            {
                NSLog(@"即时通讯：service = %@, userName = %@", model.service, model.userName);
            }
            
            NSLog(@"生日：brithdayDate = %@",person.birthday.brithdayDate);
            
            for (LJSocialProfile *model in person.socials)
            {
                NSLog(@"社交：service = %@, username = %@, urlString = %@", model.service, model.username, model.urlString);
            }
            
            for (LJContactRelation *model in person.relations)
            {
                NSLog(@"关联人：label = %@, name = %@", model.label, model.name);
            }
            
            for (LJUrlAddress *model in person.urls)
            {
                NSLog(@"URL：label = %@, urlString = %@", model.label,model.urlString);
            }
            
            NSLog(@"---------------------*******------------------------------------");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    LJPerson *personModel = self.dataSource[indexPath.row];
    
    cell.textLabel.text = personModel.fullName;
    
    LJPhone *phoneModel = personModel.phones.firstObject;
    cell.detailTextLabel.text = phoneModel.phone;

    return cell;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
