//
//  LJAddressBookManager.m
//  LJContactManager
//
//  Created by LeeJay on 2017/3/22.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "LJContactManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LJPerson.h"
#import "LJPeoplePickerDelegate.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "LJPickerDetailDelegate.h"

#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface LJContactManager () <ABNewPersonViewControllerDelegate, CNContactViewControllerDelegate>

@property (nonatomic, copy) void (^handler) (NSString *, NSString *);
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, strong) LJPeoplePickerDelegate *pickerDelegate;
@property (nonatomic, strong) LJPickerDetailDelegate *pickerDetailDelegate;
@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, strong) CNContactStore *contactStore;

@end

@implementation LJContactManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if (IOS9_OR_LATER)
        {
            _contactStore = [CNContactStore new];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_contactStoreDidChange)
                                                         name:CNContactStoreDidChangeNotification
                                                       object:nil];
        }
        else
        {
            _addressBook = ABAddressBookCreate();
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, _addressBookChange, nil);
        }
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id shared_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_instance = [[self alloc] init];
    });
    return shared_instance;
}

- (NSArray *)keys
{
    if (!_keys)
    {
        _keys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                  CNContactPhoneNumbersKey,
                  CNContactOrganizationNameKey,
                  CNContactDepartmentNameKey,
                  CNContactJobTitleKey,
                  CNContactNoteKey,
                  CNContactPhoneticGivenNameKey,
                  CNContactPhoneticFamilyNameKey,
                  CNContactPhoneticMiddleNameKey,
                  CNContactImageDataKey,
                  CNContactThumbnailImageDataKey,
                  CNContactEmailAddressesKey,
                  CNContactPostalAddressesKey,
                  CNContactBirthdayKey,
                  CNContactNonGregorianBirthdayKey,
                  CNContactInstantMessageAddressesKey,
                  CNContactSocialProfilesKey,
                  CNContactRelationsKey,
                  CNContactUrlAddressesKey];

    }
    return _keys;
}

- (LJPeoplePickerDelegate *)pickerDelegate
{
    if (!_pickerDelegate)
    {
        _pickerDelegate = [LJPeoplePickerDelegate new];
    }
    return _pickerDelegate;
}

- (LJPickerDetailDelegate *)pickerDetailDelegate
{
    if (!_pickerDetailDelegate)
    {
        _pickerDetailDelegate = [LJPickerDetailDelegate new];
        __weak typeof(self) weakSelf = self;
        _pickerDetailDelegate.handler = ^(NSString *name, NSString *phoneNum) {
            weakSelf.handler(name, phoneNum);
        };
    }
    return _pickerDetailDelegate;
}

#pragma mark - Public

- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *, NSString *))completcion
{
    self.isAdd = NO;
    [self _presentFromController:controller];
    
    self.handler = completcion;
}

- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller
{
    if (IOS9_OR_LATER)
    {
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                                     value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum]];
        contact.phoneNumbers = @[labelValue];
        CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:contact];
        contactController.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
        [controller presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
        ABRecordRef newPerson = ABPersonCreate();
        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        CFErrorRef error = NULL;
        ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phoneNum), kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue , &error);
        CFRelease(multiValue);
        picker.displayedPerson = newPerson;
        CFRelease(newPerson);
        picker.newPersonViewDelegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
        [controller presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller
{
    self.isAdd = YES;
    self.pickerDelegate.phoneNum = phoneNum;
    self.pickerDelegate.controller = controller;
   
    [self _presentFromController:controller];
}

- (void)accessContactsComplection:(void (^)(BOOL, NSArray<LJPerson *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
    
        if (authorization)
        {
            if (IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil);
            }
        }
    }];
}

- (void)accessSectionContactsComplection:(void (^)(BOOL, NSArray<LJSectionPerson *> *, NSArray<NSString *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            if (IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil, nil);
            }
        }
    }];
}

#pragma mark - ABNewPersonViewControllerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person
{
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestAddressBookAuthorization:(void (^)(BOOL authorization))completion
{
    if (IOS9_OR_LATER)
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            _blockExecute(completion, status == CNAuthorizationStatusAuthorized);
        }
    }
    else
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            _blockExecute(completion, ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized);
        }
    }
}

#pragma mark - Private

- (void)_authorizationAddressBook:(void (^) (BOOL succeed))completion
{
    if (IOS9_OR_LATER)
    {
        [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (completion)
            {
                completion(granted);
            }
        }];
    }
    else
    {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (completion)
            {
                completion(granted);
            }
        });
    }
}

void _blockExecute(void (^completion)(BOOL authorizationA), BOOL authorizationB)
{
    if (completion)
    {
        if ([NSThread isMainThread])
        {
            completion(authorizationB);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(authorizationB);
            });
        }
    }
}

- (void)_presentFromController:(UIViewController *)controller
{
    if (IOS9_OR_LATER)
    {
        CNContactPickerViewController *pc = [[CNContactPickerViewController alloc] init];
        if (self.isAdd)
        {
            pc.delegate = self.pickerDelegate;
        }
        else
        {
            pc.delegate = self.pickerDetailDelegate;
        }
        
        pc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];

        [self requestAddressBookAuthorization:^(BOOL authorization) {
            if (authorization)
            {
                [controller presentViewController:pc animated:YES completion:nil];
            }
            else
            {
                [self _showAlert];
            }
        }];
    }
    else
    {
        ABPeoplePickerNavigationController *pvc = [[ABPeoplePickerNavigationController alloc] init];
        pvc.displayedProperties = @[@(kABPersonPhoneProperty)];
        
        if (self.isAdd)
        {
            pvc.peoplePickerDelegate = self.pickerDelegate;
        }
        else
        {
            pvc.peoplePickerDelegate = self.pickerDetailDelegate;
        }
        
        [self requestAddressBookAuthorization:^(BOOL authorization) {
            
            if (authorization)
            {
                [controller presentViewController:pvc animated:YES completion:nil];
            }
            else
            {
                [self _showAlert];
            }
            
        }];
    }
}

- (void)_showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的通讯录暂未允许访问，请去设置->隐私里面授权!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)_asynAccessAddressBookWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableArray *datas = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFIndex count = CFArrayGetCount(allPeople);
        
        for (int i = 0; i < count; i++)
        {
            ABRecordRef record = CFArrayGetValueAtIndex(allPeople, i);
            LJPerson *personModel = [[LJPerson alloc] initWithRecord:record];
            [datas addObject:personModel];
        }
        
        CFRelease(allPeople);
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_asynAccessContactStoreWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *datas = [NSMutableArray array];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.keys];
        [_contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            LJPerson *person = [[LJPerson alloc] initWithCNContact:contact];
            [datas addObject:person];
            
        }];
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_sortNameWithDatas:(NSArray *)datas completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (LJPerson *person in datas)
    {
        NSString *firstLetter = [self _firstCharacterWithString:person.fullName];
        
        if (dict[firstLetter])
        {
            [dict[firstLetter] addObject:person];
        }
        else
        {
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:person, nil];
            [dict setValue:arr forKey:firstLetter];
        }
    }
    
    NSMutableArray *keys = [[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    if ([keys.firstObject isEqualToString:@"#"])
    {
        [keys addObject:keys.firstObject];
        [keys removeObjectAtIndex:0];
    }
    
    NSMutableArray *persons = [NSMutableArray array];
    
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LJSectionPerson *person = [LJSectionPerson new];
        person.key = key;
        person.persons = dict[key];
        
        [persons addObject:person];
    }];
    
    if (completcion)
    {
        completcion(persons, keys);
    }
}

- (NSString *)_firstCharacterWithString:(NSString *)string
{
    if (string.length == 0)
    {
        return @"#";
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    
    NSMutableString *pinyinString = [[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] mutableCopy];
    NSString *str = [string substringToIndex:1];
    
    // 多音字处理http://blog.csdn.net/qq_29307685/article/details/51532147
    if ([str isEqualToString:@"长"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([str isEqualToString:@"沈"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([str isEqualToString:@"厦"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([str isEqualToString:@"地"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 2) withString:@"di"];
    }
    if ([str isEqualToString:@"重"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    
    NSString *upperStr = [[pinyinString substringToIndex:1] uppercaseString];
    
    NSString *regex = @"^[A-Z]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    NSString *firstCharacter = [predicate evaluateWithObject:upperStr] ? upperStr : @"#";
    
    return firstCharacter;
}

void _addressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    [[LJContactManager sharedInstance] accessContactsComplection:[LJContactManager sharedInstance].contactChangeHandler];
    
    [[LJContactManager sharedInstance] accessSectionContactsComplection:[LJContactManager sharedInstance].sectionContactChangeHandler];
}

- (void)_contactStoreDidChange
{
    [[LJContactManager sharedInstance] accessContactsComplection:[LJContactManager sharedInstance].contactChangeHandler];
    
    [[LJContactManager sharedInstance] accessSectionContactsComplection:[LJContactManager sharedInstance].sectionContactChangeHandler];
}

- (void)dealloc
{
    if (IOS9_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
    }
    else
    {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, _addressBookChange, nil);
        if (_addressBook)
        {
            CFRelease(_addressBook);
            _addressBook = NULL;
        }
    }
}

@end
