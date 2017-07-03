//
//  MessageCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/30.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MessageCell.h"
#import "BWMacro.h"
#import "BWPlayDecorateView.h"

NSString *const MessageCellID = @"MessageCellIdentifier";

#define RANK_IMAGEVIEW_W (30)
#define RANK_IMAGEVIEW_H (16)
#define MESSAGE_LABEL_FONT (17)

@interface MessageCell ()

@property (nonatomic, strong) UIImageView *rankImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation MessageCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.rankImageView];
    }
    return self;
}


#pragma mark - Getters

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MESSAGE_TABLEVIEW_W, MESSAGE_CELL_MIN_H)];
        _messageLabel.textColor = RGB(255, 255, 255); // RGB(199, 195, 192)
        _messageLabel.font = [UIFont boldSystemFontOfSize:MESSAGE_LABEL_FONT];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        CGFloat y = (MESSAGE_CELL_MIN_H - RANK_IMAGEVIEW_H) / 2.0;
        _rankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, RANK_IMAGEVIEW_W, RANK_IMAGEVIEW_H)];
        _rankImageView.image = [UIImage imageNamed:@"rank_1"];
    }
    return _rankImageView;
}


#pragma mark - Setters

- (void)setMessage:(NSString *)message {
    _message = message;
    
    if (message.length > 3) {
        if ([message containsString:@"直播消息"]) {
            self.rankImageView.hidden = YES;
            self.messageLabel.text = [NSString stringWithFormat:@"%@", message];
            self.messageLabel.textColor = [UIColor redColor];
        } else {
            self.rankImageView.hidden = NO;
            self.rankImageView.image = [UIImage imageNamed:@"rank_21"];
            self.messageLabel.text = [NSString stringWithFormat:@"        我: %@", message];
            self.messageLabel.textColor = [UIColor whiteColor];
        }
    } else {
        self.rankImageView.hidden = NO;
        self.messageLabel.textColor = [UIColor whiteColor];
        
        int random = arc4random() % 10;
        if (random > 8) {
            self.rankImageView.image = [UIImage imageNamed:@"rank_21"];
            self.messageLabel.text = [NSString stringWithFormat:@"        山姆大叔: 来捧场了！"];
            self.messageLabel.textColor = [UIColor whiteColor];
        } else if (random > 6) {
            self.rankImageView.image = [UIImage imageNamed:@"rank_21"];
            self.messageLabel.text = [NSString stringWithFormat:@"        ⚔️剑锋⚔️ 来捧场了！"];
        } else if (random > 4) {
            self.rankImageView.image = [UIImage imageNamed:@"rank_2"];
            self.messageLabel.text = [NSString stringWithFormat:@"        💎💎💎💎💎 入座了！"];
        } else {
            self.rankImageView.image = [UIImage imageNamed:@"rank_1"];
            self.messageLabel.text = [NSString stringWithFormat:@"        我随我愿666 进场了！"];
        }
    }
    
    // 调整控件位置
    CGFloat height = [MessageCell heightForString:message];
    height = height < MESSAGE_CELL_MIN_H ? MESSAGE_CELL_MIN_H : height;
    
    CGRect frame = self.messageLabel.frame;
    frame.size.height = height;
    self.messageLabel.frame = frame;
    
//    CGRect frame2 = self.rankImageView.frame;
//    frame2.origin.y -= 1;
//    self.rankImageView.frame = frame2;
}


#pragma mark - Public Methods

// 计算消息内容的高度
+ (CGFloat)heightForString:(NSString *)string {
    string = [NSString stringWithFormat:@"占位符%@", string];
    CGSize size = [string boundingRectWithSize:CGSizeMake(MESSAGE_TABLEVIEW_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:MESSAGE_LABEL_FONT]} context:nil].size;
    return size.height;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
