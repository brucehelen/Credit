//
//  ViewController.m
//  InstantCare
//
//  Created by bruce-zhu on 15/11/27.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "ViewController.h"
#import "KMMemberManager.h"
#import "PNChart.h"
#import "AFNetworking.h"
#import "KMNetAPI.h"
#import "KMUserModel.h"
#import "APService.h"
#import "KMPushMsgModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testHTTPS];
}

#define HOST    @"https://121.42.171.115/api/v1/bids/1"

- (void)testHTTPS
{
    [ViewController getRequestWithUrl:HOST
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSString *jsonString = [[NSString alloc] initWithData:responseObject
                                                                               encoding:NSUTF8StringEncoding];

                                  NSLog(@"success %@", jsonString);
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"error: %@", error);
                              }];
}

+ (AFSecurityPolicy*)customSecurityPolicy {

    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    policy.validatesDomainName = NO;
    policy.allowInvalidCertificates = YES;
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    policy.pinnedCertificates = @[certData];

    return policy;
}

+ (AFHTTPRequestOperationManager*)customHttpRequestOperationManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [self customSecurityPolicy]; // SSL
    return manager;
}

+ (void)getRequestWithUrl:(NSString*)url success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [ViewController customHttpRequestOperationManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(operation, error);
    }];
}

@end
