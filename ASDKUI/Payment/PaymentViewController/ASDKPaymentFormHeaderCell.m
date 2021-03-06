//
//  ASDKPaymentFormHeaderCell.m
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

#import "ASDKPaymentFormHeaderCell.h"
#import "ASDKDesign.h"

@implementation ASDKPaymentFormHeaderCell

+ (instancetype)cell
{
    ASDKPaymentFormHeaderCell *cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ASDKPaymentFormHeaderCell" owner:self options:nil] objectAtIndex:0];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.textColor = [ASDKDesign colorTextDark];
    self.descriptionLabel.textColor = [ASDKDesign colorTextLight];
    [self.contentView setBackgroundColor:[ASDKDesign colorTableViewBackground]];
}

- (CGFloat)cellHeightWithSuperviewWidth:(CGFloat)width
{
    CGFloat height = self.descriptionLabel.frame.origin.y;
    
    NSString *descriptionString = self.descriptionLabel.text;
    
    if (descriptionString.length > 0)
    {
        CGRect frame = CGRectMake(0,0,width - 30,300);
        
        height += [descriptionString boundingRectWithSize:frame.size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName : self.descriptionLabel.font
                                                            }
                                                  context:nil].size.height;
    }
    
    return height + 15;
}

@end
