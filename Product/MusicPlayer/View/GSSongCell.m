//
//  GSSongCell.m
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSSongCell.h"
#import "GSSongModel.h"

@interface GSSongCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@property (strong, nonatomic) GSSongModel *songModel;

@end


@implementation GSSongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSongPath:(NSString *)songPath {
    _songPath = songPath;
    self.songModel = [[GSSongModel alloc] init];
    self.songModel.songPath = songPath;
    self.titleLabel.text = self.songModel.title;
    self.artistLabel.text = self.songModel.artist;
}

@end
