AHPagingMenuViewController
====================

AHPagingMenuViewController 1.0. Menu Paging like UINavigationController used in Tinder! Highly customizable


Roughly hacked to leverage [Font_Awesome_Swift](https://github.com/Vaberer/Font-Awesome-Swift) as icons
```swift
    let homeLabel = UILabel()
    homeLabel.setFAIcon(icon: FAType.FAHome, iconSize: 32)
    icons = [homeLabel.attributedText!,
            homeLabel.attributedText!,
            homeLabel.attributedText!,
            homeLabel.attributedText!]
    var AHController = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: icons)
```

## Demo

![AHPagingMenuViewController](https://github.com/andrehenrique92/AHPagingMenuViewController/blob/master/assets/icon1.gif)
![AHPagingMenuViewController](https://github.com/andrehenrique92/AHPagingMenuViewController/blob/master/assets/icon2.gif)


##Installation

1. Add the AHPagingMenuViewController Folder into your project. Easy, easy!


## How Use

Very easy! Just import the file

```objc
#import "AHPagingMenuViewController"
```
So, alloc with your controllers and titles (NSString or UIImage)

Obj-c

```objc
AHPagingMenuViewController *AHController = [[AHPagingMenuViewController alloc] initWithControllers: @[v1,v2,v3] andMenuItens:@[[UIImage imageNamed:@"photo"],[UIImage imageNamed:@"heart", @"Title"]];
```

Swift
```swift
var AHController = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5"])
```

Easy, easy! See more in Demo!

## Licence

MIT

## Author


Problems ? Suggestions? Send to me! andre.henrique@me.com. [My Website](http://andrehenrique.me)
Thank you! =D
