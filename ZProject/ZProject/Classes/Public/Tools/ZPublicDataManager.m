//
//  ZPublicDataManager.m
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZPublicDataManager.h"
#import "LKDBHelper.h"

@interface ZPublicDataManager ()
@property (nonatomic,strong) LKDBHelper *globalHelper;
@end

@implementation ZPublicDataManager
+ (ZPublicDataManager *)shareInstance {
    static ZPublicDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[ZPublicDataManager alloc] init];
    });
    return dataManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createDB];
    }
    return self;
}

- (void)createDB {
    _globalHelper = [self getUsingLKDBHelper];
}

- (LKDBHelper *)getUsingLKDBHelper {
    NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.db",[[NSBundle mainBundle] bundleIdentifier]]];
    LKDBHelper *db = [[LKDBHelper alloc] initWithDBPath:dbpath];
    return db;
}

- (BOOL)insertOrUpdateModel:(NSObject *)modelData {
    if (modelData.rowid) {
        return [_globalHelper updateToDB:modelData where:nil];
    }else{
        return [_globalHelper insertToDB:modelData];
    }
}

- (BOOL)addOrUpdateModel:(ZBaseModel *)modelData{
    ZBaseModel *dbModelData = [self getDBModelData:[modelData class]];
    if (dbModelData) {
        modelData.rowid = dbModelData.rowid;
        return [_globalHelper updateToDB:modelData where:nil];
    }else{
        return [_globalHelper insertToDB:modelData];
        
    }
}

- (void)addOrUpdateModelBlcok:(ZBaseModel *)modelData callback:(void (^)(BOOL))block {
    ZBaseModel *dbModelData = [self getDBModelData:[modelData class]];
    if (dbModelData) {
        modelData.rowid = dbModelData.rowid;
        [_globalHelper updateToDB:modelData where:nil callback:block];
    }else{
        [_globalHelper insertToDB:modelData callback:block];
    }
}

- (BOOL)insertModel:(ZBaseModel *)modelData {
    return [_globalHelper insertToDB:modelData];
}

- (BOOL)deleteModel:(ZBaseModel *)modelData {
    return [_globalHelper deleteToDB:modelData];
}

-(id)getDBModelData:(Class)modelClass
{
    NSArray *userArr = [_globalHelper search:modelClass where:nil orderBy:nil offset:0 count:1];
    if ([userArr count]>0) {
        ZBaseModel *dbmodelData = userArr[0];
        return dbmodelData;
    }
    return nil;
}


-(NSArray *)getDBModelArr:(Class)modelClass {
    NSArray *userArr = [_globalHelper search:modelClass where:nil orderBy:nil offset:0 count:10000];
    if ([userArr count]>0) {
        return userArr;
    }
    return nil;
}

- (NSArray *)getDBModelArr:(Class)modelClass offset:(NSInteger)offset count:(NSInteger)count {
    NSArray *userArr = [_globalHelper search:modelClass where:nil orderBy:[NSString stringWithFormat:@"rowid desc"] offset:offset count:count];
    if ([userArr count]>0) {
        return userArr;
    }
    return nil;
}

- (NSArray *)getDBModelArr:(Class)modelClass
                   offset:(NSInteger)offset
                    count:(NSInteger)count
                  orderBy:(NSString *)orderByStr {
    NSArray *userArr = [_globalHelper search:modelClass where:nil orderBy:orderByStr offset:offset count:count];
    if ([userArr count]>0) {
        return userArr;
    }
    return nil;
}


- (void)clearModel:(Class)modelClass {
    [_globalHelper dropTableWithClass:modelClass];
}

- (void)clearModel:(NSString *)modelClassName withWhere:(NSString *)where {
    [_globalHelper deleteWithTableName:modelClassName where:where];
}

- (void)clearAllData {
    [_globalHelper executeDB:^(FMDatabase* db) {
        FMResultSet* set = [db executeQuery:@"select name from sqlite_master where type='table'"];
        NSMutableArray* dropTables = [NSMutableArray arrayWithCapacity:0];
        
        while ([set next]) {
            [dropTables addObject:[set stringForColumnIndex:0]];
        }
        
        [set close];
        
        for (NSString* tableName in dropTables) {
            if ([tableName hasPrefix:@"sqlite_"] == NO && ![tableName isEqualToString:@"ZUserModel"]) {
                NSString* dropTable = [NSString stringWithFormat:@"drop table %@", tableName];
                [db executeUpdate:dropTable];
                [self->_globalHelper dropTableWithTableName:tableName];
            }
        }
    }];
}

- (NSArray*)searchModel:(Class)baseModelClass
                 where:(NSString *)sqlStr {
    NSArray *searchArr = [_globalHelper search:baseModelClass where:sqlStr orderBy:nil offset:0 count:1];
    return searchArr;
}
@end
