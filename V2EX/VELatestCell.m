//
//  VELatestCell.m
//  V2EX
//
//  Created by wengjia on 15/8/11.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VELatestCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VELatestCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation VELatestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithStatusModel:(VEStatusModel *)statusModel{
    self.statusModel = statusModel;
    [self.avatarImageView sd_setImageWithURL:[[NSURL alloc]initWithScheme:@"http" host:statusModel.member.avatarLarge.host path:statusModel.member.avatarLarge.path]];
    self.contentLabel.text = statusModel.title;
    self.timeLabel.text = [[VEStatusModel dateFormatter]stringFromDate:statusModel.created];
}

@end
