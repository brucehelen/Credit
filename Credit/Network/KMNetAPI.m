//
//  KMNetAPI.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/4.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMNetAPI.h"
#import "KMUserRegisterModel.h"
#import "AFNetworking.h"
#import "KMUserRegisterModel.h"

@interface KMNetAPI()

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) KMRequestResultBlock requestBlock;

@end

@implementation KMNetAPI

+ (instancetype)manager
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableData data];
    }

    return self;
}

- (void)postWithURL:(NSString *)url body:(NSString *)body block:(KMRequestResultBlock)block
{
    // debug
    DMLog(@"-> %@  %@", url, body);

    NSData *httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval = 60;
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:httpBody];
    
    self.requestBlock = block;
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark - 取得定位记录
- (void)requestLocationSetWithIMEI:(NSString *)imei
                             block:(KMRequestResultBlock)block
{
    self.requestBlock = block;
    NSString *url = [NSString stringWithFormat:@"http://%@/service/m/location/set?id=%@&key=%@&target=%@&count=10",
                     kServerAddress,
                     member.userModel.id,
                     member.userModel.key,
                     imei];
    DMLog(@"-> %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *jsonString = [[NSString alloc] initWithData:responseObject
                                                     encoding:NSUTF8StringEncoding];
        DMLog(@"<- %@", jsonString);
        if (self.requestBlock) {
            self.requestBlock(0, jsonString);
        }
        self.requestBlock = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.requestBlock) {
            self.requestBlock((int)error.code, nil);
        }
        self.requestBlock = nil;
    }];
}

/**
 *  更新提醒信息
 *
 *  @param key     updateClinic, updateMedical, updateCustom
 *  @param content POST JSON
 *  @param block   服务器返回block
 */
- (void)updateRemindInfoWithKey:(NSString *)key
                        Content:(NSString *)content
                          block:(KMRequestResultBlock)block
{
    NSString *url = [NSString stringWithFormat:@"http://%@/service/m/device/remind/%@", kServerAddress, key];

    [self postWithURL:url body:content block:block];
}

#pragma mark - 连接成功
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse
{
    self.data.length = 0;
}

#pragma mark 存储数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incomingData
{
    [self.data appendData:incomingData];
}

#pragma mark 完成加载
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonData = [[NSString alloc] initWithData:self.data
                                               encoding:NSUTF8StringEncoding];

    // debug
    DMLog(@"<- %@", jsonData);

    if (self.requestBlock) {
        self.requestBlock(0, jsonData);
    }

    self.requestBlock = nil;
}

#pragma mark 连接错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.requestBlock) {
        self.requestBlock((int)error.code, nil);
    }

    self.requestBlock = nil;
}

@end
