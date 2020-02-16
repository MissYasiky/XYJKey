//
//  XYJSettingViewController.m
//  key
//
//  Created by MissYasiky on 2020/2/2.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJSettingViewController.h"
#import "XYJSimpleLabelCell.h"

static NSString * const kPasswordGeneratorCellIdentifier = @"passwordGeneratorCellIdentifier";

static NSString * const kExportCellIdentifier = @"exportGeneratorCellIdentifier";

@interface XYJSettingViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *versionLabel;

@end

@interface XYJSettingViewController ()

@end

@implementation XYJSettingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SETTING";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.versionLabel];
}

- (void)dealloc {
    _tableView.delegate = nil;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XYJ_ScreenWidth, XYJ_ScreenHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = [XYJSimpleLabelCell height];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        
        [_tableView registerClass:[XYJSimpleLabelCell class] forCellReuseIdentifier:kPasswordGeneratorCellIdentifier];
        [_tableView registerClass:[XYJSimpleLabelCell class] forCellReuseIdentifier:kExportCellIdentifier];
    }
    return _tableView;
}

- (UILabel *)versionLabel {
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.frame = CGRectMake(0, XYJ_ScreenHeight - 50 - 13, XYJ_ScreenWidth, 13);
        _versionLabel.font = [UIFont fontWithName:XYJ_Regular_Font size:11];
        _versionLabel.textColor = [XYJColorUtils colorWithHexString:XYJ_Text_Color alpha:0.5];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString* appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString* buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        _versionLabel.text = [NSString stringWithFormat:@"Version %@ Build %@", appVersion, buildVersion];
    }
    return _versionLabel;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        XYJSimpleLabelCell *cell = (XYJSimpleLabelCell *)[tableView dequeueReusableCellWithIdentifier:kPasswordGeneratorCellIdentifier forIndexPath:indexPath];
        [cell setCellIconImageName:@"setting_icon_password"];
        [cell setLabelText:@"Password Generator"];
        return cell;
    } else if (indexPath.row == 1) {
        XYJSimpleLabelCell *cell = (XYJSimpleLabelCell *)[tableView dequeueReusableCellWithIdentifier:kExportCellIdentifier forIndexPath:indexPath];
        [cell setCellIconImageName:@"setting_icon_export"];
        [cell setStyle:XYJSimpleLabelCellOnlyLabel];
        [cell setLabelText:@"Export"];
        return cell;
    } else {
        return [XYJSimpleLabelCell new];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
