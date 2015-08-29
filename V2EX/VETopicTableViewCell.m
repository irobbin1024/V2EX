//
//  VETopicTableViewCell.m
//  V2EX
//
//  Created by baiyang on 8/25/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VETopicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Formatter.h"

@interface VETopicTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation VETopicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTopicModel:(VETopicModel *)topicModel {
    self.topicModel = topicModel;
    
    [self.avatarImageView sd_setImageWithURL:[[NSURL alloc]initWithScheme:@"http" host:topicModel.member.avatarLarge.host path:topicModel.member.avatarLarge.path]];
    self.contentLabel.text = topicModel.title;
    self.timeLabel.text = [[NSDate dateFormatter] stringFromDate:topicModel.created];
    
    [self.timeLabel sizeToFit];
    [self.contentLabel sizeToFit];
}

+ (CGFloat)heightWithTopicModel:(VETopicModel *)topicModel {
    return 95;
}

@end
