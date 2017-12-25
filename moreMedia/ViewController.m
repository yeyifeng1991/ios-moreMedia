//
//  ViewController.m
//  moreMedia
//
//  Created by 叶子 on 2017/12/21.
//  Copyright © 2017年 叶义峰. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSURL * mediaUrl;
}
@property(nonatomic,strong)UIImagePickerController * imagePicker;
@property (nonatomic,strong)AVPlayerViewController * avPlayer;
// 录音
@property (nonatomic,strong) AVAudioRecorder * recorder;
@property (nonatomic,strong) AVAudioPlayer * audioPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
/*
 1.视频文件路径
 2.播放窗口大小的设置 全屏/小屏幕
 3.播放视频文件
 
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        //如果是录音文件，则在播放的时候把录音文件存入的文件路径拿到
//        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record"];
        // 播放本地文件
        NSString * path = [[NSBundle mainBundle] pathForResource:@"黎允文 - 赵子龙" ofType:@"mp3"];
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];// 创建播放机对象
        [_audioPlayer prepareToPlay]; // 准备播放
    }
    return _audioPlayer;
}
- (AVAudioRecorder *)recorder
{
    if (!_recorder) {
        // 录音保存路径
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record"];
        // 录音设置
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        //采样率
        [dic setValue:@(44100) forKey:AVSampleRateKey];
        //录音格式
        [dic setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        //录音通道
        [dic setValue:@(1) forKey:AVNumberOfChannelsKey];
        // 录音质量
        [dic setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        //
        _recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:path] settings:dic error:nil];
        [_recorder prepareToRecord]; //准备录音
    }
    return _recorder;
}
- (AVPlayerViewController *)avPlayer
{
    if (!_avPlayer) {
        _avPlayer = [[AVPlayerViewController alloc]init];
        //创建Player对象 -- 视频文件路径
        _avPlayer.player = [[AVPlayer alloc]initWithURL:mediaUrl];
        // 播放窗口大小
        self.avPlayer.view.frame = CGRectMake(100, 100, 400, 400);
        [self.view addSubview:self.avPlayer.view];
        //1.全屏播放
//        [self presentViewController:self.avPlayer animated:YES completion:nil];
        
        
    }
    return _avPlayer;
}
-(UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        // 采集源类型
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 媒体类型 #import <MobileCoreServices/MobileCoreServices.h>

        _imagePicker.mediaTypes = [NSArray arrayWithObject:(__bridge NSString*)(kUTTypeImage)];
//        _imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh; //视频质量
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
#pragma mark - 多媒体数据的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取媒体类型
    NSString * type =info[UIImagePickerControllerMediaType];
    // 如果媒体类型是图片类型
    if ([type isEqualToString:(__bridge NSString*)(kUTTypeImage)]) {
        UIImage * image = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
// 取消采集图片的处理
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 选择图片
- (IBAction)selectImage:(id)sender {
    // 通过摄像头采集
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else // 通过图片库来采集
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - 录音功能
- (IBAction)pickVideo:(UIButton*)sender {
   
    
    if (sender.isSelected ==NO) {
        [self.recorder record];
        sender.selected = YES;
    }
    else
    {
        [self.recorder stop];
        sender.selected = NO;
    }
    
}
#pragma mark - 播放按钮

- (IBAction)playMedia:(id)sender {
    // 播放
    [self.audioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
