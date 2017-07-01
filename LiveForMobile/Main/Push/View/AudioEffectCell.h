//
//  AudioEffectCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/26.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioEffectModel;

UIKIT_EXTERN NSString *const AudioEffectCellID;

#define AUDIOEFFECTCELLH (51 - 2)
#define AUDIOEFFECTCELLW (54)

/**
 音效 Cell
 */
@interface AudioEffectCell : UICollectionViewCell

@property (nonatomic, strong) AudioEffectModel *audioEffect; // 音效

@end
