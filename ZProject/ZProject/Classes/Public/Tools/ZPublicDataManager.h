//
//  ZPublicDataManager.h
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBaseModel.h"

@interface ZPublicDataManager : NSObject
-(BOOL)insertOrUpdateModel:(NSObject *)modelData;
-(BOOL)addOrUpdateModel:(ZBaseModel *)modelData;
-(void)addOrUpdateModelBlcok:(ZBaseModel *)modelData
                    callback:(void (^)(BOOL))block;
-(BOOL)insertModel:(ZBaseModel *)modelData;
-(BOOL)deleteModel:(ZBaseModel *)modelData;


-(NSArray*)searchModel:(Class)baseModelClass
                 where:(NSString *)sqlStr;

-(id)getDBModelData:(Class)modelClass;
-(NSArray *)getDBModelArr:(Class)modelClass;
-(NSArray *)getDBModelArr:(Class)modelClass offset:(NSInteger)offset count:(NSInteger)count;
-(NSArray *)getDBModelArr:(Class)modelClass
                   offset:(NSInteger)offset
                    count:(NSInteger)count
                  orderBy:(NSString *)orderByStr;
-(void)clearModel:(Class)modelClass;
-(void)clearAllData;
@end
