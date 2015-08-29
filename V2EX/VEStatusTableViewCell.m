//
//  VEStatusTableViewCell.m
//  V2EX
//
//  Created by baiyang on 8/25/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEStatusTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface VEStatusTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation VEStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithStatusModel:(VEStatusModel *)statusModel {
    self.statusModel = statusModel;
    
    [self.avatarImageView sd_setImageWithURL:[[NSURL alloc]initWithScheme:@"http" host:statusModel.member.avatarLarge.host path:statusModel.member.avatarLarge.path]];
    self.contentLabel.text = statusModel.title;
    self.timeLabel.text = [[VEStatusModel dateFormatter]stringFromDate:statusModel.created];
    
    [self.timeLabel sizeToFit];
    [self.contentLabel sizeToFit];
}

+ (CGFloat)heightWithStatusModel:(VEStatusModel *)statusModel {
    return 95;
}

@end
