//
//  GSMPPlayingViewController.m
//  Product
//
//  Created by guo on 2018/8/27.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSMPPlayingViewController.h"
#import "GSMusicPlayerTool.h"
#import "GSSongModel.h"
#import "GSSongMessageModel.h"
#import "GSTimeTool.h"

@interface GSMPPlayingViewController () {
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImgView;
@property (weak, nonatomic) IBOutlet UILabel *costTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *playingModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *showMenuBtn;

//@property (strong, nonatomic) GSMusicPlayerTool *playerTool;

@end

@implementation GSMPPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.playerTool = [GSMusicPlayerTool sharedPlayer];
    
    [self setupDataOnce];
    
    [self addTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupDataOnce) name:@"setupDataByRemoteControll" object:nil];
}

- (void)viewDidLayoutSubviews {
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeTimer];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)addRotationAnimation {
    [self.artworkImgView.layer removeAnimationForKey:@"rotation"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.toValue = @(M_PI * 2);
    animation.duration = 30;
    animation.repeatCount = MAXFLOAT;
    
    animation.removedOnCompletion = NO;
    
    [self.artworkImgView.layer addAnimation:animation forKey:@"rotation"];
}

- (void)pauseRotationAnimation {
    CFTimeInterval pausedTime = [self.artworkImgView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.artworkImgView.layer.speed = 0.0;
    self.artworkImgView.layer.timeOffset = pausedTime;
}

- (void)resumeRotationAnimation {
    CFTimeInterval pausedTime = self.artworkImgView.layer.timeOffset;
    self.artworkImgView.layer.speed = 1.0;
    self.artworkImgView.layer.timeOffset = 0.0;
    self.artworkImgView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.artworkImgView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.artworkImgView.layer.beginTime = timeSincePause;
}

- (void)setupDataOnce {
    self.titleLabel.text = [GSMusicPlayerTool sharedPlayer].playingSongModel.title;
    self.artistLabel.text = [GSMusicPlayerTool sharedPlayer].playingSongModel.artist;
    self.artworkImgView.image = [GSMusicPlayerTool sharedPlayer].playingSongModel.coverImage;
    
    GSSongMessageModel *songMessageModel = [[GSMusicPlayerTool sharedPlayer] getSongMessageModel];
    self.totalTimeLabel.text = songMessageModel.totalTimeFormat;
    self.costTimeLabel.text = songMessageModel.costTimeFormat;
    self.progressSlider.value = 1.0 * songMessageModel.costTime / songMessageModel.totalTime;
    
    for (UIView *view in self.bgImgView.subviews) {
        [view removeFromSuperview];
    }
    self.bgImgView.image = [GSMusicPlayerTool sharedPlayer].playingSongModel.coverImage;
    self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImgView.layer.masksToBounds = YES;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.bgImgView.frame.size.width, self.bgImgView.frame.size.height);
    [self.bgImgView addSubview:effectView];
    
    [self addRotationAnimation];
    
    if ([GSMusicPlayerTool sharedPlayer].isPlaying) {
        self.playBtn.selected = false;
        [self resumeRotationAnimation];
    } else {
        self.playBtn.selected = true;
        [self pauseRotationAnimation];
    }
    
    [self setPlayingModeTitle];
}

- (void)setPlayingModeTitle {
    NSString *playingMode;
    switch ([[GSMusicPlayerTool sharedPlayer] getPlayingMode]) {
        case GSMPPlayingModeListLoop:
            playingMode = @"列表循环";
            break;
        case GSMPPlayingModeRandomPlay:
            playingMode = @"随机播放";
            break;
        case GSMPPlayingModeSingleLoop:
            playingMode = @"单曲循环";
            break;
    }
    [self.playingModeBtn setTitle:playingMode forState:UIControlStateNormal];
}

- (void)setupViews {
    self.artworkImgView.layer.cornerRadius = self.artworkImgView.frame.size.width * 0.5;
    self.artworkImgView.layer.masksToBounds = YES;
}

- (void)updateData {
    GSSongMessageModel *songMessageModel = [[GSMusicPlayerTool sharedPlayer] getSongMessageModel];
    self.costTimeLabel.text = songMessageModel.costTimeFormat;
    self.progressSlider.value = 1.0 * songMessageModel.costTime / songMessageModel.totalTime;
//    [[GSMusicPlayerTool sharedPlayer] setLockScreenInfo];
}

- (void)addTimer {
    if (!_timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
        _timer = timer;
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playOrPauseMusic:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (!sender.selected) {
        [[GSMusicPlayerTool sharedPlayer] play];
        [self resumeRotationAnimation];
    } else {
        [[GSMusicPlayerTool sharedPlayer] pause];
        [self pauseRotationAnimation];
    }
}

- (IBAction)preSong:(UIButton *)sender {
    [[GSMusicPlayerTool sharedPlayer] preMusic];
    [self setupDataOnce];
}

- (IBAction)nextSong:(UIButton *)sender {
    [[GSMusicPlayerTool sharedPlayer] nextMusic];
    [self setupDataOnce];
}

- (IBAction)changePlayingMode:(UIButton *)sender {
    [[GSMusicPlayerTool sharedPlayer] changePlayingMode];
    [self setPlayingModeTitle];
}


- (IBAction)sliderValueDidChange:(UISlider *)sender {
    NSTimeInterval totalTime = [[GSMusicPlayerTool sharedPlayer] getSongMessageModel].totalTime;
    NSTimeInterval currentTime = sender.value * totalTime;
    [[GSMusicPlayerTool sharedPlayer] seekTo:currentTime];
    self.costTimeLabel.text = [GSTimeTool getFormatTime:currentTime];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setupDataByRemoteControll" object:nil];
}

@end
