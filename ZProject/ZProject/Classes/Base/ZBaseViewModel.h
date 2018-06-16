//
//  ZBaseViewModel.h
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionHandler)(NSError *error);

@protocol BaseViewModelDelegate <NSObject>
@optional
/** 获取数据 */
- (void)getDataFromNetCompletionHandler:(completionHandler)completionHandler;
/** 刷新 */
- (void)refreshDataCompletionHandler:(completionHandler)completionHandler;
/** 获取更多 */
- (void)getMoreDataCompletionHandler:(completionHandler)completionHandler;

@end

@interface ZBaseViewModel : NSObject<BaseViewModelDelegate>
@property (nonatomic,assign) CGFloat postTextHeight;
@property (nonatomic,strong) NSMutableAttributedString *sin_textPost;

@property (strong, nonatomic) NSMutableArray *dataMArr;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

/** 取消任务 */
- (void)cacelTask;
/** 暂停任务 */
- (void)suspendTask;
/** 继续任务 */
- (void)resumeTask;

@end
