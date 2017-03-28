//
//  ContactTableViewCell.m
//  Demo
//
//  Created by LeeJay on 2017/3/27.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "LJPerson.h"

@interface ContactTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

@end

@implementation ContactTableViewCell

- (void)setModel:(LJPerson *)model
{
    self.iconImageV.image = model.image ? model.image : [UIImage imageNamed:@"hand portrait"];
    self.nameLabel.text = model.fullName;
    LJPhone *phoneModel = model.phones.firstObject;
    self.phoneNumLabel.text = phoneModel.phone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageV.layer.cornerRadius = 30;
    self.iconImageV.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
