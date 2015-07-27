//
//  VEHotCell.m
//  
//
//  Created by baiyang on 15/7/27.
//
//

#import "VEHotCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VEHotCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation VEHotCell

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
}

+ (CGFloat)heightWithStatusModel:(VEStatusModel *)statusModel {
    return 95;
}

@end
