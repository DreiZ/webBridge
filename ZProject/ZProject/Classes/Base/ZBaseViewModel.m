//
//  ZBaseViewModel.m
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZBaseViewModel.h"

@implementation ZBaseViewModel

- (void)cacelTask {
    [self.dataTask cancel];
}
- (void)suspendTask {
    [self.dataTask suspend];
}
- (void)resumeTask {
    [self.dataTask resume];
}
- (NSMutableArray *)dataMArr {
    if (!_dataMArr) {
        _dataMArr = [NSMutableArray new];
    }
    return _dataMArr;
}

- (CGFloat)postTextHeight:(CGSize)maxSize {
    if(_postTextHeight == 0) {
        CGSize textSize = maxSize;
        _postTextHeight = ceilf([self.sin_textPost boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height);
    }
    return _postTextHeight;
}

- (NSMutableAttributedString *)sin_textPostText:(NSString *)text{
    if(_sin_textPost == nil && !kIsEmpty(text))
    {
        NSMutableAttributedString *postTextM = [[NSMutableAttributedString alloc] initWithString:text];
        
        
        postTextM.lineSpacing = 4.0;
        postTextM.font = [UIFont systemFontOfSize:15];
        postTextM.color = [UIColor blackColor];
        postTextM.backgroundColor = [UIColor clearColor];
        postTextM.paragraphSpacing = 7.0;
        
        _sin_textPost = postTextM;
    }
    return _sin_textPost;
}
@end
