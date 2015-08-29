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
@property (weak, nonatomic) IBOutlet UILabel *replieLabel;
@property (weak, nonatomic) IBOutlet UIButton *nodeButton;

@end

@implementation VETopicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTopicModel:(VETopicModel *)topicModel isSimple:(BOOL)isSimple{
    self.topicModel = topicModel;
    self.isSimple = isSimple;
    
    if (isSimple) {
        self.replieLabel.hidden = YES;
        self.nodeButton.hidden = YES;
    } else {
        self.replieLabel.hidden = NO;
        self.nodeButton.hidden = NO;
    }
    
    [self.avatarImageView sd_setImageWithURL:[[NSURL alloc]initWithScheme:@"http" host:topicModel.member.avatarLarge.host path:topicModel.member.avatarLarge.path]];
    self.contentLabel.text = topicModel.title;
    self.timeLabel.text = [[NSDate dateFormatter] stringFromDate:topicModel.created];
    
    [self.timeLabel sizeToFit];
    [self.contentLabel sizeToFit];
}

- (IBAction)nodeAction:(id)sender {
}

@end
