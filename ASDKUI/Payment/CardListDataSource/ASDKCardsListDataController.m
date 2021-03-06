//
//  ASDKCardsListDataController.m
//  ASDKUI
//
// Copyright (c) 2016 TCS Bank
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ASDKCardsListDataController.h"

static ASDKCardsListDataController * __cardsListDataController = nil;

@interface ASDKCardsListDataController ()

@property (nonatomic, strong) ASDKAcquiringSdk *acquiringSdk;

@property (nonatomic, strong) NSArray *externalCards;
@property (nonatomic, strong) NSString *customerKey;

@end

@implementation ASDKCardsListDataController

+ (instancetype)instance
{
    @synchronized(self)
    {
        return __cardsListDataController;
    }
}

+ (instancetype)cardsListDataControllerWithAcquiringSdk:(ASDKAcquiringSdk *)acquiringSdk
                                            customerKey:(NSString *)customerKey
{
    @synchronized(self)
    {
        if (![__cardsListDataController.customerKey isEqualToString:customerKey])
        {
            [ASDKCardsListDataController resetSharedInstance];
        }
        
        if (!__cardsListDataController)
        {
            __cardsListDataController = [[ASDKCardsListDataController alloc] init];
            __cardsListDataController.customerKey = customerKey;
        }
        
        __cardsListDataController.acquiringSdk = acquiringSdk;
        
        return __cardsListDataController;
    }
}

+ (void)resetAcquiringSdk
{
    @synchronized(self)
    {
        if (__cardsListDataController)
        {
            __cardsListDataController.acquiringSdk = nil;
        }
    }
}

- (void)updateCardsListWithSuccessBlock:(void (^)())onSuccess
                             errorBlock:(void (^)(ASDKAcquringSdkError *error))onError
{
    if (self.acquiringSdk && self.customerKey)
    {
        __weak typeof(self) weakSelf = self;
        
        [self.acquiringSdk getCardListWithCustomerKey:self.customerKey
                                              success:^(ASDKGetCardListResponse *response)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             
             if (strongSelf)
             {
                 strongSelf.externalCards = response.cards;
             }
             if (onSuccess)
             {
                 onSuccess();
             }
         }
                                              failure:^(ASDKAcquringSdkError *error)
         {
             if (onError)
             {
                 onError(error);
             }
         }];
    }
    else
    {
        if (onSuccess)
        {
            onSuccess();
        }
    }
}

- (void)removeCardWithCardId:(NSNumber *)cardId
                successBlock:(void (^)())onSuccess
                  errorBlock:(void (^)(ASDKAcquringSdkError *error))onError
{
    if (self.acquiringSdk && self.customerKey)
    {
        __weak typeof(self) weakSelf = self;
        
        [self.acquiringSdk removeCardWithCustomerKey:self.customerKey
                                              cardId:cardId
                                             success:^(ASDKRemoveCardResponse *response)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if (strongSelf)
             {
                 [strongSelf updateCardsListWithSuccessBlock:^
                  {
                      if (onSuccess)
                      {
                          onSuccess();
                      }
                  }
                                                  errorBlock:^(ASDKAcquringSdkError *error)
                  {
                      if (onError)
                      {
                          onError(error);
                      }
                  }];
             }
         }
                                             failure:^(ASDKAcquringSdkError *error)
         {
             if (onError)
             {
                 onError(error);
             }
         }];
    }
    else
    {
        if (onSuccess)
        {
            onSuccess();
        }
    }
}

+ (void)resetSharedInstance
{
    @synchronized(self)
    {
        __cardsListDataController = nil;
    }
}

@end
