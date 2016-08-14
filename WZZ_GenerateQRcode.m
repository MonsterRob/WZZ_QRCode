//
//  WZZ_GenerateQRcode.m
//  WZZ_QRCode
//
//  Created by 王召洲 on 16/8/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "WZZ_GenerateQRcode.h"

@interface WZZ_GenerateQRcode ()

@end

@implementation WZZ_GenerateQRcode

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    //CIFilter;
    
    //CIImage
    [self setupUI];
    
}
-(void)setupUI {
    UITextField *txt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    txt.borderStyle = UITextBorderStyleRoundedRect;
    txt.backgroundColor = [UIColor colorWithRed: arc4random_uniform(256)/255.0  green:arc4random_uniform(256)/255.0 blue: arc4random_uniform(256)/255.0 alpha:1 ];
    txt.placeholder = @"输入你想生成的二维码文字";
    txt.autocorrectionType = UITextAutocorrectionTypeNo;
    txt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt.center = self.view.center;
    txt.tag = 1;
    
    [self.view addSubview:txt];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, 50);
    btn.center = CGPointMake(self.view.center.x, 200);
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(generateQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)generateQRCode :(UIButton *)sender {
    
    UITextField *txt = [self.view viewWithTag:1];
    NSString *str = txt.text;
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    if (filter) {
        
        [filter setValue:data forKey:@"inputMessage"];
        [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
        
    }
    for (NSString *key in filter.inputKeys) {
        NSLog(@"%@",key);
    }
    CIImage *ciImg = [filter outputImage];
    //UIImage *img = [UIImage imageWithCIImage:ciImg scale:0.2 orientation:(UIImageOrientationUp)];
    UIImage *img = [self imageWithCIImage:ciImg size:200];
    UIImageView *imgV = [[UIImageView alloc]initWithImage:img];
    imgV.center = CGPointMake(self.view.center.x, 550);
    [self.view addSubview:imgV];
    
         
}
-(UIImage *)imageWithCIImage:(CIImage *)img size:(CGFloat)size {
    CGRect extent = CGRectIntegral(img.extent);
    
    // size 图片大小 w=h
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = scale * CGRectGetHeight(extent);
    size_t heigth = scale * CGRectGetWidth(extent);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    // 位图上下文
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, heigth, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    // CI上下文
    CIContext *ci_context = [CIContext contextWithOptions:nil];
    
    // 图片引用
    CGImageRef bitmapImg = [ci_context createCGImage:img fromRect:extent];
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImg);
    // 获取最终结果
    
    CGImageRef scaledImg = CGBitmapContextCreateImage(bitmapRef);
   
    // 释放资源
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImg);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:scaledImg];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
