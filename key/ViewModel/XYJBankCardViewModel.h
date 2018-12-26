//
//  XYJBankCardViewModel.h
//  key
//
//  Created by MissYasiky on 2018/12/15.
//  Copyright © 2018 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XYJBankCardViewModelType) {
    XYJBankCardViewModelTypeAddNew = 0,
    XYJBankCardViewModelTypeEdit = 1,
    XYJBankCardViewModelTypeDetail
};

@interface XYJBankCardViewModel : NSObject

@property (nonatomic, assign, readonly) XYJBankCardViewModelType type;
@property (nonatomic, strong, readonly) NSMutableDictionary *inputDataDict;

@property (nonatomic, strong, readonly) NSArray *tableDataSourceArray;
@property (nonatomic, strong, readonly) NSDictionary *placeholderDict;
@property (nonatomic, strong, readonly) NSDictionary *keyboardTypeDict;

@property (nonatomic, strong, readonly) NSArray *pickerDataArray;
@property (nonatomic, assign) NSInteger pickerSelectedIndex;

@property(nonatomic, copy) void (^completeHandler)(BOOL success);

- (instancetype)initWithData:(NSDictionary *)dict type:(XYJBankCardViewModelType)type;

- (NSInteger)sectionForTable;

- (NSInteger)rowForTableAtSection:(NSInteger)section;

- (NSString *)keyAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)dataSourceAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)selectedBankName;

- (void)selectBankAtIndex:(NSInteger)index;

- (BOOL)isCreditCard;

- (void)creditCard:(BOOL)creditCard;

- (NSString *)inputDataAtIndexPath:(NSIndexPath *)indexPath;

- (void)inputData:(NSString *)content atIndexPath:(NSIndexPath *)indexPath;

- (void)save;

- (void)updateData:(NSDictionary *)dict;

@end
