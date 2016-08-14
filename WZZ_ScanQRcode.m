//
//  WZZ_ScanQRcode.m
//  WZZ_QRCode
//
//  Created by 王召洲 on 16/8/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "WZZ_ScanQRcode.h"

@import AVFoundation;
@interface WZZ_ScanQRcode ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic) AVCaptureDeviceInput * input;// 设备输入源
@property (strong,nonatomic) AVCaptureMetadataOutput * output;// 数据输出源
@property (strong,nonatomic) AVCaptureDevice * device;// 设备
@property (strong,nonatomic) AVCaptureSession * session;//会话
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * previewLayer;//预览
@end

@implementation WZZ_ScanQRcode

-(AVCaptureSession *)session {
    if (_session == nil) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
    }
    return _session;
}
-(AVCaptureDevice *)device {
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
-(AVCaptureDeviceInput *)input {
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:NULL];
        
    }
    return _input;
}
-(AVCaptureMetadataOutput *)output {
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        [ _output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _output;
}
-(AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [self.session addInput:self.input];
        [self.session addOutput:self.output];
        _previewLayer.frame = self.view.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _previewLayer;
}




-(void)configOutputAndInput {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:NULL];
    [self.session addInput:self.input];
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.session addOutput:self.output];
    
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame =self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:self.previewLayer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self configOutputAndInput];
    [self.view.layer addSublayer:self.previewLayer];
    // 必须在添加之后再决定元数据类型
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [self setupUI];
}
-(void)setupUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, 50);
    btn.center = CGPointMake(self.view.center.x, 500);
    btn.backgroundColor = [UIColor colorWithRed: arc4random_uniform(256)/255.0  green:arc4random_uniform(256)/255.0 blue: arc4random_uniform(256)/255.0 alpha:1 ];
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"开始扫描" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startToScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void)startToScan {
    NSLog(@"start");
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects && metadataObjects.count != 0) {
        AVMetadataMachineReadableCodeObject *code = [metadataObjects firstObject];
        
        if ([code.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"%@",code.stringValue);
            
        }
        else {
            NSLog(@"不是二维码");
        }
        [self.session stopRunning];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
