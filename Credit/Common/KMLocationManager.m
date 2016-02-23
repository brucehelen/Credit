//
//  KMLocationManager.m
//  3GSW
//
//  Created by MissionHealth on 15/10/8.
//
//

#import "KMLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface KMLocationManager() <BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) CLGeocoder *geo;
@property (nonatomic, copy) NSString *address;

/**
 *  百度反向地址解析
 */
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, strong) KMGeocodeCompletionHandler geoBlock;

@end

@implementation KMLocationManager

+ (instancetype)locationManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;

    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });

    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        switch (member.userMapType) {
            case KM_USER_MAP_TYPE_IOS:
            case KM_USER_MAP_TYPE_IOS_CHINA:
                _geo = [[CLGeocoder alloc] init];
                break;
            case KM_USER_MAP_TYPE_BAIDU:
                self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
                self.geoCodeSearch.delegate = self;
                break;
            default:
                break;
        }
    }

    return self;
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    if (self.geoBlock) {
        self.geoBlock(result.address);
    }
}

- (void)startLocationWithLocation:(CLLocation *)location
                      resultBlock:(KMGeocodeCompletionHandler)addressBlock
{
    switch (member.userMapType) {
        case KM_USER_MAP_TYPE_IOS:
        case KM_USER_MAP_TYPE_IOS_CHINA:
        {
            [_geo reverseGeocodeLocation:location
                       completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                           if (error) {
                               NSLog(@"*** startLocationWithLocation[%f, %f] error: %@",
                                     location.coordinate.longitude,
                                     location.coordinate.latitude,
                                     error);
                               if (addressBlock) {
                                   addressBlock(nil);
                               }
                               return;
                           }
                           
                           NSString *realaddress = [[placemarks firstObject] name];
                           self.address = realaddress;
                           if (addressBlock) {
                               addressBlock(realaddress);
                           }
                       }];
        } break;
        case KM_USER_MAP_TYPE_BAIDU:
        {
            self.geoBlock = addressBlock;
            BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
            reverseGeocodeSearchOption.reverseGeoPoint = location.coordinate;
            BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
            if (flag == NO) {
                NSLog(@"*** 反geo检索发送失败");
                if (self.geoBlock) {
                    self.geoBlock(nil);
                }
            }
        } break;
        default:
            break;
    }
}

@end
