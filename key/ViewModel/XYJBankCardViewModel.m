//
//  XYJBankCardViewModel.m
//  key
//
//  Created by MissYasiky on 2018/12/15.
//  Copyright © 2018 netease. All rights reserved.
//

#import "XYJBankCardViewModel.h"
#import "XYJBankCardDao.h"
#import "XYJCacheUtils.h"

@interface XYJBankCardViewModel ()

@property (nonatomic, assign) XYJBankCardViewModelType type;
@property (nonatomic, strong) NSMutableDictionary *inputDataDict;

@property (nonatomic, strong) NSArray *tableDataSourceArray;
@property (nonatomic, strong) NSDictionary *placeholderDict;
@property (nonatomic, strong) NSDictionary *keyboardTypeDict;

@property (nonatomic, strong) NSArray *pickerDataArray;

@end

@implementation XYJBankCardViewModel

#pragma mark - initialize

- (instancetype)initWithData:(NSDictionary *)dict type:(XYJBankCardViewModelType)type {
    self = [super init];
    if (self) {
        NSAssert((_type >= 0 && _type <= XYJBankCardViewModelTypeDetail), @"BankCard ViewModel's type is wrong");
        _type = type;
        
        if (_type > 0) {
            NSAssert(dict, @"BankCard ViewModel lack of source data");
        }
        
        if (_type == XYJBankCardViewModelTypeAddNew) {
            _pickerSelectedIndex = 0;
            
            _inputDataDict = [NSMutableDictionary new];
            [_inputDataDict setObject:@(self.pickerSelectedIndex) forKey:XYJBankName];
            [_inputDataDict setObject:@(0) forKey:XYJBankCreditCard];
        } else {
            _inputDataDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            
            _pickerSelectedIndex = [_inputDataDict[XYJBankName] integerValue];
        }
    }
    return self;
}

- (instancetype)init {
    self = [self initWithData:nil type:XYJBankCardViewModelTypeAddNew];
    return self;
}

#pragma mark - Getter & Setter

- (NSArray *)tableDataSourceArray {
    if (_tableDataSourceArray == nil) {
        _tableDataSourceArray = @[
                                  @[@[XYJBankName, @"银行"],
                                    @[XYJBankCardID, @"账号"],
                                    @[XYJBankCreditCard, @"信用卡"],
                                    @[XYJBankECardPassword, @"网银密码"],
                                    @[XYJBankQueryPassword, @"查询密码"],
                                    @[XYJBankWithdrawalPassword, @"取款密码"]
                                    ],
                                  @[@[XYJBankRemark, @"备注"]]
                                  ];
    }
    return _tableDataSourceArray;
}

- (NSDictionary *)placeholderDict {
    if (_placeholderDict == nil) {
        _placeholderDict = @{XYJBankCardID:@"请输入银行账号",
                             XYJBankECardPassword:@"请输入网银密码",
                             XYJBankQueryPassword:@"请输入查询密码",
                             XYJBankWithdrawalPassword:@"请输入取款密码"};
    }
    return _placeholderDict;
}

- (NSDictionary *)keyboardTypeDict {
    if (_keyboardTypeDict == nil) {
        _keyboardTypeDict = @{XYJBankCardID:@(UIKeyboardTypeNumberPad),
                       XYJBankECardPassword:@(UIKeyboardTypeDefault),
                       XYJBankQueryPassword:@(UIKeyboardTypeNumberPad),
                  XYJBankWithdrawalPassword:@(UIKeyboardTypeNumberPad)};
    }
    return _keyboardTypeDict;
}

- (NSArray *)pickerDataArray {
    if (_pickerDataArray == nil) {
        _pickerDataArray = [XYJCacheUtils bankNameArray];
    }
    return _pickerDataArray;
}

#pragma mark - Public

- (NSInteger)sectionForTable {
    return [self.tableDataSourceArray count];
}

- (NSInteger)rowForTableAtSection:(NSInteger)section {
    NSArray *array = self.tableDataSourceArray[section];
    return [array count];
}

- (NSString *)keyAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowArray = [self dataSourceAtIndexPath:indexPath];
    return rowArray[0];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowArray = [self dataSourceAtIndexPath:indexPath];
    return rowArray[1];
}

- (NSArray *)dataSourceAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray = self.tableDataSourceArray[indexPath.section];
    NSArray *rowArray = sectionArray[indexPath.row];
    return rowArray;
}

- (NSString *)selectedBankName {
    return self.pickerDataArray[self.pickerSelectedIndex];
}

- (void)selectBankAtIndex:(NSInteger)index {
    if (self.type == XYJBankCardViewModelTypeDetail) {
        return;
    }
    if (index < 0 || index > [self.pickerDataArray count]) {
        return;
    }
    self.pickerSelectedIndex = index;
    [self.inputDataDict setObject:@(self.pickerSelectedIndex) forKey:XYJBankName];
}

- (BOOL)isCreditCard {
    return [self.inputDataDict[XYJBankCreditCard] boolValue];
}

- (void)creditCard:(BOOL)creditCard {
    if (self.type == XYJBankCardViewModelTypeDetail) {
        return;
    }
    [self.inputDataDict setObject:@(creditCard) forKey:XYJBankCreditCard];
}

- (NSString *)inputDataAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 2)) {
        return nil;
    }
    NSString *key = [self keyAtIndexPath:indexPath];
    return self.inputDataDict[key];
}

- (void)inputData:(NSString *)content atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 2)) {
        return;
    }
    NSString *key = [self keyAtIndexPath:indexPath];
    [self.inputDataDict setObject:content forKey:key];
}

- (void)save {
    NSString *cardId = self.inputDataDict[XYJBankCardID];
    if (cardId == nil || cardId.length == 0) {
        return;
    }
    if (self.type == XYJBankCardViewModelTypeAddNew) {
        double createTime = [[NSDate date] timeIntervalSince1970];
        [self.inputDataDict setObject:@(createTime) forKey:XYJBankCreateTime];
        
        [[XYJBankCardDao sharedDao] insertData:self.inputDataDict completionBlock:self.completeHandler];
    } else if (self.type == XYJBankCardViewModelTypeEdit) {
        [[XYJBankCardDao sharedDao] updateData:self.inputDataDict completionBlock:self.completeHandler];
    }
}

- (void)updateData:(NSDictionary *)dict {
    if (self.type != XYJBankCardViewModelTypeDetail) {
        return;
    }
    self.inputDataDict = [dict mutableCopy];
}

@end
