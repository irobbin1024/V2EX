//
//  VEReplieTableViewCell.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEReplieTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Formatter.h"
#import "TTTAttributedLabel.h"

@interface VEReplieTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *replieLabel;

@end

@implementation VEReplieTableViewCell

- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithReplie:(VEReplieModel *)replie {
    self.replieModel = replie;
    
    [self.avatarImageView sd_setImageWithURL:[[NSURL alloc]initWithScheme:@"http" host:replie.member.avatarLarge.host path:replie.member.avatarLarge.path]];
    self.nameLabel.text = replie.member.userName;
    self.timeLabel.text = [[NSDate dateFormatter]stringFromDate:replie.created];
    self.replieLabel.text = replie.content;
}


@end
