

#import "LoginViewController.h"
#import "UMSocial.h"
#import "SinaLoginModel.h"
#import "MJExtension.h"
#import "MainViewController.h"
#import "BottomBar.h"
#import "UIButton+WebCache.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)cancelBtn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)weixinLogin {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            CYGLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }
        
    });
    
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        CYGLog(@"SnsInformation is %@",response.data);
    }];
}

- (IBAction)sinaLogin {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
           // CYGLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
    //在授权完成后调用获取用户信息的方法
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
       // CYGLog(@"SnsInformation is %@",response.data);
        //把新浪用户信息存到模型
        SinaLoginModel *model = [SinaLoginModel mj_objectWithKeyValues:response.data];
        
        _model = model;
        
        //拿到bottombar的personBtn
        MainViewController *mainVc = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        BottomBar *bar = [mainVc.view.subviews lastObject];
        
        UIButton *personBtn = (UIButton *)[bar.subviews lastObject];
        personBtn.layer.cornerRadius = personBtn.width/2;
        personBtn.layer.masksToBounds = YES;
        
        [personBtn setImage:nil forState:UIControlStateNormal];
        [personBtn setImage:nil forState:UIControlStateSelected];
        [personBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.profile_image_url] forState:UIControlStateNormal];
        [personBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.profile_image_url] forState:UIControlStateSelected];

        _changeBlock(model.profile_image_url,model.screen_name);
        
        //成功回到person页面
        [self cancelBtn];
    }];
    
    //获取好友列表调用下面的方法,由于新浪官方限制，获取好友列表只能获取到30%好友
//    [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"SnsFriends is %@",response.data);
//    }];
    
    //删除授权调用下面的方法
//    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"response is %@",response);
//    }];
    
}

- (IBAction)qqLogin {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            CYGLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
    //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
//    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"SnsInformation is %@",response.data);
//    }];
}

@end
