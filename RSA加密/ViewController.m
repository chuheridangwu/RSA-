//
//  ViewController.m
//  RSA加密
//
//  Created by DYM on 16/7/31.
//  Copyright © 2016年 龙少. All rights reserved.
//

#import "ViewController.h"
#import "RSAUtil.h"

@interface ViewController ()
{
    NSString *_rsaStr;
    NSString *_public;
    NSString *_priva;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //加密
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 100, 50)];
    [btn addTarget:self action:@selector(clickbtn) forControlEvents:UIControlEventTouchDown];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    
    //解密
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 100, 100)];
    [btn1 addTarget:self action:@selector(clickbtn1) forControlEvents:UIControlEventTouchDown];
    btn1.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn1];
    
    _rsaStr = @"这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，这是测试数据，";
}

- (void)clickbtn{
    
    //生成一个随机的8位字符串，作为des加密数据的key,对数据进行des加密，对加密后的数据用公钥再进行一次rsa加密
    _public = [RSAUtil encryptString:_rsaStr publicKey:RSA_Public_key];
    NSLog(@"%@",_public);
    
}

- (void)clickbtn1{
    
    _priva = [RSAUtil decryptString:_public privateKey:RSA_Privite_key];
    NSLog(@"%@",_priva);
}


//分段加密  -- 如果不使用不需要调用
- (NSString*)rsa:(NSString*)str{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < str.length; i = i + 25 ) {
        if ((i + 25) > str.length ) {
            NSString *RSAStr = [RSAUtil encryptString:[str substringWithRange:NSMakeRange(i, str.length - i)] publicKey:RSA_Public_key];
            [arr addObject:RSAStr];
        }else{
            
            NSLog(@"%@   ---",[str substringWithRange:NSMakeRange(i,25)]);
            NSString *RSAStr = [RSAUtil encryptString:[str substringWithRange:NSMakeRange(i,25)] publicKey:RSA_Public_key];
            [arr addObject:RSAStr];
        }
        
        if ((i + 25) == str.length) {
            break;
        }
    }
    
    NSError *error;
    // 如果是要字符串类型的{@"a":"1",@"b":"1"}，使用 options:kNilOptions
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:&error];
    
    if (!error) {
        return [[NSString  alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
    
}


@end
