platform :ios, '8.0'

inhibit_all_warnings!
#use_modular_headers!
def macro_Pods
    pod 'Masonry'
    pod 'MobileVLCKit'
    pod 'FMDB'
    pod 'MJRefresh'
    pod 'MJExtension'
    pod 'DBGuestureLock', '~> 0.0.2'
    pod 'ReactiveObjC'
    pod 'IQKeyboardManager'
    pod 'MBProgressHUD'
    pod 'Google-Mobile-Ads-SDK'
    pod 'SnapKit'
    pod 'RxSwift', '~> 4.0'
    pod 'RxCocoa',  '~> 4.0'
    pod 'RxAtomic',:modular_headers => true
end

def macro_pro_Pods
    pod 'Masonry'
    pod 'MobileVLCKit'
    pod 'FMDB'
    pod 'MJRefresh'
    pod 'MJExtension'
    pod 'DBGuestureLock', '~> 0.0.2'
    pod 'ReactiveObjC'
    pod 'IQKeyboardManager'
    pod 'MBProgressHUD'
end



target 'WhatsPlayer' do
	macro_Pods
end

target 'WhatsPlayer-Pro' do
    macro_pro_Pods
end

