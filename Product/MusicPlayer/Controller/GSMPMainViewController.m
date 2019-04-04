//
//  GSMPMainViewController.m
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSMPMainViewController.h"
#import "GSSongMenuTool.h"
#import "GSSongCell.h"
#import "GSMPPlayingViewController.h"
#import "GSMusicPlayerTool.h"
#import "GSSongModel.h"
#import "GSMPRemoteControllTool.h"

@interface GSMPMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *songMenuTableView;

@property (strong, nonatomic) NSMutableArray *songMenuArr;

@end

@implementation GSMPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GSSongMenuTool *smTool = [GSSongMenuTool defaultTool];
    [smTool createDefaultDir];
    self.songMenuArr = [smTool getSongMenuArr];
    
    [[GSMPRemoteControllTool defaultInstance] startUpdateLockScreenInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSongMenu) name:@"refreshSongMenuNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshSongMenu {
    self.songMenuArr = [[GSSongMenuTool defaultTool] getSongMenuArr];
    [self.songMenuTableView reloadData];
}

#pragma mark - UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songMenuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSSongCell *cell = (GSSongCell *)[tableView dequeueReusableCellWithIdentifier:@"SongCellIdentifier" forIndexPath:indexPath];
    cell.songPath = [self.songMenuArr objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playSelectedSong"]) {
        GSMusicPlayerTool *playerTool = [GSMusicPlayerTool sharedPlayer];
        GSSongModel *songModel = [[GSSongModel alloc] init];
        songModel.songPath = self.songMenuArr[self.songMenuTableView.indexPathForSelectedRow.row];
        playerTool.playingSongModel = songModel;
        [playerTool resetPlayingMenu:self.songMenuArr];
        playerTool.playingIndex = self.songMenuTableView.indexPathForSelectedRow.row;
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)songMenuArr {
    if (!_songMenuArr) {
        _songMenuArr = [[NSMutableArray alloc] init];
    }
    
    return _songMenuArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
