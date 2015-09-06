//
//  VEMemberTableViewCell.m
//  V2EX
//
//  Created by wengjia on 15/9/5.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VEMemberTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface VEMemberTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation VEMemberTableViewCell

- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTitle:(NSString *) title Context:(id) context IsShowImage:(BOOL) isShowImage {
    if (isShowImage) {
        self.contextLabel.hidden = YES;
        self.avatarImageView.hidden = NO;
        NSURL *avatarLarge = context;
        [self.avatarImageView sd_setImageWithURL:[[NSURL alloc] initWithScheme:@"http" host:avatarLarge.host path:avatarLarge.path]];
    }else {
        self.contextLabel.hidden = NO;
        self.avatarImageView.hidden = YES;
        NSString *value = context;
        self.contextLabel.text = value;
    }
    self.titleLabel.text = title;
}

@end