# IceButler_iOS
>  냉장고를 지켜주는 나만의 집사😺
<br>

## Tech Stack
### iOS
<img src="https://img.shields.io/badge/swift-orange?style=for-the-badge&logo=swift&logoColor=white">

### DB
<img src="https://img.shields.io/badge/amazon rds-527FFF?style=for-the-badge&logo=amazonrds&logoColor=white"> <img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white"> <img src="https://img.shields.io/badge/jasypt-0769AD?style=for-the-badge&logoColor=white"> <img src="https://img.shields.io/badge/redis-DC382D?style=for-the-badge&logo=redis&logoColor=white"> <img src="https://img.shields.io/badge/firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white"> <img src="https://img.shields.io/badge/amazon s3-569A31?style=for-the-badge&logo=amazons3&logoColor=white">

### CI/CD
<img src="https://img.shields.io/badge/jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white"> <img src="https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=white"> <img src="https://img.shields.io/badge/docker hub-2496ED?style=for-the-badge&logo=docker&logoColor=white"> 

### Deploy
<img src="https://img.shields.io/badge/amazon ec2-FF9900?style=for-the-badge&logo=amazon ec2&logoColor=white"> <img src="https://img.shields.io/badge/amazon sqs-FF4F8B?style=for-the-badge&logo=amazonsqs&logoColor=white"> <img src="https://img.shields.io/badge/amazon api gateway-FF4F8B?style=for-the-badge&logo=amazonapigateway&logoColor=white"> <img src="https://img.shields.io/badge/aws lambda-FF9900?style=for-the-badge&logo=awslambda&logoColor=white"> 

### Develop Tool
<img src="https://img.shields.io/badge/intelliJ-000000?style=for-the-badge&logo=intellij idea&logoColor=white"> <img src="https://img.shields.io/badge/postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white"> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> 
<br> 
<br>

## Project Architecture
<details>
<summary>FINAL ARCHITECTURE</summary>
    
![스크린샷 2023-06-07 오전 1 09 2](https://github.com/IceButler/IceButler_Server/assets/90203250/16d4f6ad-5d01-4ecc-8fbb-4afacca7d55e)
</details>

<details>
<summary>CI/CD</summary>
    
![image 370](https://github.com/IceButler/IceButler_Server/assets/90203250/cec1115d-1014-4d57-80a4-7ba44408509d)
</details>

<details>
<summary>AWS Lambda</summary>
    
 ![image 340](https://github.com/IceButler/IceButler_Server/assets/90203250/f215a8d5-8201-4bcb-9033-fdaad5633e2b)
</details>

<details>
<summary>AWS SQS</summary>
    
 ![image 397](https://github.com/IceButler/IceButler_Server/assets/90203250/6f76861e-8335-4df7-b6db-2e0790882cfe)
</details>
<br>

## Project Structure

<details>
<summary>Details</summary>

```jsx
├── App
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Data
│   ├── Model
│   │   ├── Auth
│   │   │   ├── AuthRequestModel.swift
│   │   │   └── AuthResponseModel.swift
│   │   ├── Cart
│   │   │   ├── CartRequestModel.swift
│   │   │   ├── CartResponseModel.swift
│   │   │   └── KakaoMapDataModel.swift
│   │   ├── Food
│   │   │   ├── FoodRequestModel.swift
│   │   │   └── FoodResponseModel.swift
│   │   ├── Fridge
│   │   │   ├── FridgeRequestModel.swift
│   │   │   └── FridgeResponseModel.swift
│   │   ├── GeneralResponseModel.swift
│   │   ├── Graph
│   │   │   └── GraphResponseModel.swift
│   │   ├── Image
│   │   │   ├── ImageRequestModel.swift
│   │   │   └── ImageResponseModel.swift
│   │   ├── MyFridge
│   │   │   └── MyFridgeResponseModel.swift
│   │   ├── Notification
│   │   │   └── NotificationResponseModel.swift
│   │   ├── Recipe
│   │   │   └── RecipeResponseModel.swift
│   │   └── User
│   │       └── UserResponseModel.swift
│   └── Service
│       ├── Auth
│       │   └── AuthService.swift
│       ├── Cart
│       │   ├── CartService.swift
│       │   └── KakaoMapService.swift
│       ├── Fridge
│       │   └── FridgeService.swift
│       ├── Graph
│       │   └── GraphService.swift
│       ├── Image
│       │   └── ImageService.swift
│       ├── Recipe
│       │   └── RecipeService.swift
│       ├── User
│       │   └── UserService.swift
│       └── 래ㅐㅇ
│           └── FoodService.swift
├── Global
│   ├── Enums
│   │   ├── AuthProvider.swift
│   │   ├── FoodCategory.swift
│   │   ├── FridgeType.swift
│   │   ├── ImageDir.swift
│   │   ├── PolicyType.swift
│   │   ├── ProfileEditMode.swift
│   │   └── RecipeCategory.swift
│   ├── Extensions
│   │   ├── String+.swift
│   │   ├── UIButton+.swift
│   │   ├── UICollectionViewFlowLayout+.swift
│   │   ├── UIColor+.swift
│   │   └── UIDevice+.swift
│   ├── Resource
│   │   └── Assets.xcassets
│   │       ├── AccentColor.colorset
│   │       │   └── Contents.json
│   │       ├── AppIcon.appiconset
│   │       │   ├── Contents.json
│   │       │   └── 냉집사 런처 아이콘 1.png
│   │       ├── Contents.json
│   │       ├── IceButlerIcon
│   │       │   ├── Contents.json
│   │       │   ├── addButtonIcon.imageset
│   │       │   │   ├── AddButtonIcon.png
│   │       │   │   ├── AddButtonIcon@2x.png
│   │       │   │   ├── AddButtonIcon@3x.png
│   │       │   │   └── Contents.json
│   │       │   ├── addFridgeTitleIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── addFridgeTitleIcon@1x.png
│   │       │   │   ├── addFridgeTitleIcon@2x.png
│   │       │   │   └── addFridgeTitleIcon@3x.png
│   │       │   ├── add_icon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── add_icon@1x.png
│   │       │   │   ├── add_icon@2x.png
│   │       │   │   └── add_icon@3x.png
│   │       │   ├── addressIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── addressIcon@1x.png
│   │       │   │   ├── addressIcon@2x.png
│   │       │   │   └── addressIcon@3x.png
│   │       │   ├── alarmIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── alarmIcon.png
│   │       │   │   ├── alarmIcon@2x 1.png
│   │       │   │   └── alarmIcon@3x.png
│   │       │   ├── appleLoginIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── Logo - SIWA - Left-aligned - White - Large.svg
│   │       │   ├── back.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── back.png
│   │       │   ├── backIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── backIcon.png
│   │       │   │   ├── backIcon@2x.png
│   │       │   │   └── backIcon@3x.png
│   │       │   ├── barcodeAddIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── barcodeAddIcon.png
│   │       │   │   ├── barcodeAddIcon@2x.png
│   │       │   │   └── barcodeAddIcon@3x.png
│   │       │   ├── cancelButtonIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── cancelButtonIcon.png
│   │       │   │   ├── cancelButtonIcon@2x.png
│   │       │   │   └── cancelButtonIcon@3x.png
│   │       │   ├── cartBarTitle.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── cartBarTitle.png
│   │       │   ├── categoryCloseIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── categoryCloseIcon.png
│   │       │   │   ├── categoryCloseIcon@2x.png
│   │       │   │   └── categoryCloseIcon@3x.png
│   │       │   ├── categoryOpenIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── categoryOpenIcon.png
│   │       │   │   ├── categoryOpenIcon@2x.png
│   │       │   │   └── categoryOpenIcon@3x.png
│   │       │   ├── check.fill.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── check.fill.png
│   │       │   ├── check.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── check.png
│   │       │   ├── chevron_right.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── chevron_right@1x.png
│   │       │   │   ├── chevron_right@2x.png
│   │       │   │   └── chevron_right@3x.png
│   │       │   ├── chevron_right_blue.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── chevron_right_blue@1x.png
│   │       │   │   ├── chevron_right_blue@2x.png
│   │       │   │   └── chevron_right_blue@3x.png
│   │       │   ├── clock.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── clock@1x.png
│   │       │   │   ├── clock@2x.png
│   │       │   │   └── clock@3x.png
│   │       │   ├── crown.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── crown@1x.png
│   │       │   │   ├── crown@2x.png
│   │       │   │   └── crown@3x.png
│   │       │   ├── currentLocationIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── currentLocationIcon@1x.png
│   │       │   │   ├── currentLocationIcon@2x.png
│   │       │   │   └── currentLocationIcon@3x.png
│   │       │   ├── datePickerOpenIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── datePickerOpenIcon.png
│   │       │   │   ├── datePickerOpenIcon@2x.png
│   │       │   │   └── datePickerOpenIcon@3x.png
│   │       │   ├── defaultProfile.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── defaultProfile@1x.png
│   │       │   │   ├── defaultProfile@2x.png
│   │       │   │   └── defaultProfile@3x.png
│   │       │   ├── deleteIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── deleteIcon.png
│   │       │   │   ├── deleteIcon@2x.png
│   │       │   │   └── deleteIcon@3x.png
│   │       │   ├── eat.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── eat.png
│   │       │   │   ├── eat@2x.png
│   │       │   │   └── eat@3x.png
│   │       │   ├── editIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── editIcon.png
│   │       │   │   ├── editIcon@2x.png
│   │       │   │   └── editIcon@3x.png
│   │       │   ├── ellipsis_vertical.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── ellipsis_vertical@1x.png
│   │       │   │   ├── ellipsis_vertical@2x.png
│   │       │   │   └── ellipsis_vertical@3x.png
│   │       │   ├── fridge.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── fridge@1x.png
│   │       │   │   ├── fridge@2x.png
│   │       │   │   └── fridge@3x.png
│   │       │   ├── fridgeSelectIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── fridgeSelectIcon.png
│   │       │   │   ├── fridgeSelectIcon@2x.png
│   │       │   │   └── fridgeSelectIcon@3x.png
│   │       │   ├── gpt.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── gpt.svg
│   │       │   ├── iceButlerMainIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── iceButlerIcon.png
│   │       │   │   ├── iceButlerIcon@2x.png
│   │       │   │   └── iceButlerIcon@3x.png
│   │       │   ├── imageAddIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── imageAddIcon.png
│   │       │   │   ├── imageAddIcon@2x.png
│   │       │   │   └── imageAddIcon@3x.png
│   │       │   ├── kakaoLoginIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── kakao_login_medium_wide.png
│   │       │   ├── leftAnchor.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── leftAnchor.svg
│   │       │   ├── logo_kakao.imageset
│   │       │   │   ├── 12.png
│   │       │   │   ├── 12@2x.png
│   │       │   │   ├── 12@3x.png
│   │       │   │   └── Contents.json
│   │       │   ├── map.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── map.png
│   │       │   ├── mapIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── mapIcon@1x.png
│   │       │   │   ├── mapIcon@2x.png
│   │       │   │   └── mapIcon@3x.png
│   │       │   ├── navigationIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── navigation.png
│   │       │   │   ├── navigation@2x.png
│   │       │   │   └── navigation@3x.png
│   │       │   ├── notSelectedFridge.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── notSelectedFridge@1x.png
│   │       │   │   ├── notSelectedFridge@2x.png
│   │       │   │   └── notSelectedFridge@3x.png
│   │       │   ├── pencil.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── pencil@1x.png
│   │       │   │   ├── pencil@2x.png
│   │       │   │   └── pencil@3x.png
│   │       │   ├── person.fill.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── person.fill@1x.png
│   │       │   │   ├── person.fill@2x.png
│   │       │   │   └── person.fill@3x.png
│   │       │   ├── phoneIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── phoneIcon@1x.png
│   │       │   │   ├── phoneIcon@2x.png
│   │       │   │   └── phoneIcon@3x.png
│   │       │   ├── pin.fill.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── pin.fill@1x.png
│   │       │   │   ├── pin.fill@2x.png
│   │       │   │   └── pin.fill@3x.png
│   │       │   ├── pin.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── pin@1x.png
│   │       │   │   ├── pin@2x.png
│   │       │   │   └── pin@3x.png
│   │       │   ├── rightAnchor.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── rightAnchor.svg
│   │       │   ├── rightArrow.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── moveWasteIcon.png
│   │       │   │   ├── moveWasteIcon@2x.png
│   │       │   │   └── moveWasteIcon@3x.png
│   │       │   ├── search.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── search.png
│   │       │   ├── searchAddIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── searchAddIcon.png
│   │       │   │   ├── searchAddIcon@2x.png
│   │       │   │   └── searchAddIcon@3x.png
│   │       │   ├── searchIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── searchIcon.png
│   │       │   │   ├── searchIcon@2x.png
│   │       │   │   └── searchIcon@3x.png
│   │       │   ├── selectedCheck.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── selectedCheck.png
│   │       │   ├── selectedFridge.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── selectedFridge@1x.png
│   │       │   │   ├── selectedFridge@2x.png
│   │       │   │   └── selectedFridge@3x.png
│   │       │   ├── trash.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── trash@1x.png
│   │       │   │   ├── trash@2x.png
│   │       │   │   └── trash@3x.png
│   │       │   ├── userImageAddIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── userImageIcon.png
│   │       │   │   ├── userImageIcon@2x.png
│   │       │   │   └── userImageIcon@3x.png
│   │       │   ├── userImageIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── userIamge.png
│   │       │   │   ├── userIamge@2x.png
│   │       │   │   └── userIamge@3x.png
│   │       │   ├── wasteIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── wasteIcon.png
│   │       │   │   ├── wasteIcon@2x.png
│   │       │   │   └── wasteIcon@3x.png
│   │       │   ├── white_cart_icon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── image 177.png
│   │       │   ├── white_trash_icon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── image 176.png
│   │       │   │   ├── trash@2x.png
│   │       │   │   └── trash@3x.png
│   │       │   ├── writeAddIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── writeAddIcon.png
│   │       │   │   ├── writeAddIcon@2x 1.png
│   │       │   │   └── writeAddIcon@3x.png
│   │       │   └── xmark.imageset
│   │       │       ├── Contents.json
│   │       │       ├── xmark@1x.png
│   │       │       ├── xmark@2x.png
│   │       │       └── xmark@3x.png
│   │       ├── Icon
│   │       │   └── Contents.json
│   │       ├── RecipeIcon
│   │       │   ├── Contents.json
│   │       │   ├── alarmClockCircle.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── Group 34915.png
│   │       │   │   ├── Group 34916.png
│   │       │   │   └── Group 34917.png
│   │       │   ├── blueDownArrow.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── blue_down_arrow 1.png
│   │       │   │   ├── blue_down_arrow 2.png
│   │       │   │   └── blue_down_arrow.png
│   │       │   ├── blueFilledCircle.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── Ellipse 197.png
│   │       │   │   ├── Ellipse 198.png
│   │       │   │   └── Ellipse 199.png
│   │       │   ├── deleteCircle.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── deleteCircle 1.png
│   │       │   │   ├── deleteCircle 2.png
│   │       │   │   └── deleteCircle.png
│   │       │   ├── emptyBlackStar.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── ion_star-outline 1.png
│   │       │   │   ├── ion_star-outline 2.png
│   │       │   │   └── ion_star-outline.png
│   │       │   ├── emptyStar.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── emptyStar 1.png
│   │       │   │   ├── emptyStar 2.png
│   │       │   │   └── emptyStar.png
│   │       │   ├── filledStar.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── ion_star 1.png
│   │       │   │   ├── ion_star 2.png
│   │       │   │   └── ion_star.png
│   │       │   ├── horizontalEllipsisCircle.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── Group 34915.png
│   │       │   │   ├── Group 34916.png
│   │       │   │   └── ellipsis_horizontal.png
│   │       │   ├── peopleCircle.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── Group 34915.png
│   │       │   │   ├── Group 34916.png
│   │       │   │   └── Group 34917.png
│   │       │   ├── plusCircle.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── plusCircle 1.png
│   │       │   │   ├── plusCircle 2.png
│   │       │   │   └── plusCircle.png
│   │       │   ├── recipeCategoryCloseIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── recipeCategoryCloseIcon 1.png
│   │       │   │   ├── recipeCategoryCloseIcon 2.png
│   │       │   │   └── recipeCategoryCloseIcon.png
│   │       │   ├── recipeCategoryOpenIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── categoryOpenIcon 1.png
│   │       │   │   ├── categoryOpenIcon 2.png
│   │       │   │   └── categoryOpenIcon.png
│   │       │   ├── redReportIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── grommet-icons_emergency 1.png
│   │       │   │   ├── grommet-icons_emergency 2.png
│   │       │   │   └── grommet-icons_emergency.png
│   │       │   ├── searchWhiteIcon.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── icon_search 1.png
│   │       │   │   ├── icon_search 2.png
│   │       │   │   └── icon_search.png
│   │       │   ├── smallStar.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── smallStar 1.png
│   │       │   │   ├── smallStar 2.png
│   │       │   │   └── smallStar.png
│   │       │   └── star.imageset
│   │       │       ├── Contents.json
│   │       │       ├── star 1.png
│   │       │       ├── star 2.png
│   │       │       └── star.png
│   │       ├── Refrigerator
│   │       │   ├── Contents.json
│   │       │   ├── fridgeAdd.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── fridgePlus.png
│   │       │   │   ├── fridgePlus@2x.png
│   │       │   │   └── fridgePlus@3x.png
│   │       │   ├── noFridge.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── noFridge.png
│   │       │   │   ├── noFridge@2x.png
│   │       │   │   └── noFridge@3x.png
│   │       │   ├── right_arrow.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── right_arrow 1.png
│   │       │   │   ├── right_arrow 2.png
│   │       │   │   └── right_arrow.png
│   │       │   └── sad.imageset
│   │       │       ├── Contents.json
│   │       │       ├── Vector 1.png
│   │       │       ├── Vector 2.png
│   │       │       └── Vector.png
│   │       ├── cartIcon
│   │       │   ├── Contents.json
│   │       │   ├── completeBuying.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   ├── completeBuying@1x.png
│   │       │   │   ├── completeBuying@2x.png
│   │       │   │   └── completeBuying@3x.png
│   │       │   └── delete.imageset
│   │       │       ├── Contents.json
│   │       │       ├── delete@1x.png
│   │       │       ├── delete@2x.png
│   │       │       └── delete@3x.png
│   │       ├── mypageIcon
│   │       │   ├── Contents.json
│   │       │   ├── logout.imageset
│   │       │   │   ├── 3-1.png
│   │       │   │   └── Contents.json
│   │       │   ├── myFridges.imageset
│   │       │   │   ├── 1-1.png
│   │       │   │   └── Contents.json
│   │       │   ├── myRecipe.imageset
│   │       │   │   ├── 1-2.png
│   │       │   │   └── Contents.json
│   │       │   ├── privatePolicy.imageset
│   │       │   │   ├── 4-2.png
│   │       │   │   └── Contents.json
│   │       │   ├── proVersion.imageset
│   │       │   │   ├── 2-1.png
│   │       │   │   └── Contents.json
│   │       │   ├── right_arrow_gray.imageset
│   │       │   │   ├── Contents.json
│   │       │   │   └── right_arrow_gray.png
│   │       │   ├── signout.imageset
│   │       │   │   ├── 3-2.png
│   │       │   │   └── Contents.json
│   │       │   └── tos.imageset
│   │       │       ├── 4-1.png
│   │       │       └── Contents.json
│   │       └── tabIcon
│   │           ├── Contents.json
│   │           ├── cart.fill.imageset
│   │           │   ├── Contents.json
│   │           │   ├── cart.fill@1x.png
│   │           │   ├── cart.fill@2x.png
│   │           │   └── cart.fill@3x.png
│   │           ├── cart.imageset
│   │           │   ├── Contents.json
│   │           │   ├── cart@1x.png
│   │           │   ├── cart@2x.png
│   │           │   └── cart@3x.png
│   │           ├── main.fill.imageset
│   │           │   ├── Contents.json
│   │           │   ├── fridge.fill@1x.png
│   │           │   ├── fridge.fill@2x.png
│   │           │   └── fridge.fill@3x.png
│   │           ├── main.imageset
│   │           │   ├── Contents.json
│   │           │   ├── fridge@1x.png
│   │           │   ├── fridge@2x.png
│   │           │   └── fridge@3x.png
│   │           ├── mypage.fill.imageset
│   │           │   ├── Contents.json
│   │           │   ├── mypage.fill@1x.png
│   │           │   ├── mypage.fill@2x.png
│   │           │   └── mypage.fill@3x.png
│   │           ├── mypage.imageset
│   │           │   ├── Contents.json
│   │           │   ├── mypage@1x.png
│   │           │   ├── mypage@2x.png
│   │           │   └── mypage@3x.png
│   │           ├── recipe.fill.imageset
│   │           │   ├── Contents.json
│   │           │   ├── recipe.fill@1x.png
│   │           │   ├── recipe.fill@2x.png
│   │           │   └── recipe.fill@3x.png
│   │           └── recipe.imageset
│   │               ├── Contents.json
│   │               ├── recipe@1x.png
│   │               ├── recipe@2x.png
│   │               └── recipe@3x.png
│   └── Splash
│       ├── Base.lproj
│       │   └── LaunchScreen.storyboard
│       └── ko.lproj
│           └── LaunchScreen.strings
├── GoogleService-Info.plist
├── IceButler_iOS.entitlements
├── Info.plist
├── Network
│   └── APIManger.swift
└── Presentation
    ├── Cells
    │   ├── AddFoodSearchResultTableViewCell.swift
    │   ├── CartMainTableViewCell.swift
    │   ├── CartMainTableViewCell.xib
    │   ├── ChatGptCell.swift
    │   ├── ChatGptCell.xib
    │   ├── CompleteBuyingTableViewCell.swift
    │   ├── FoodAddImageCell.swift
    │   ├── FoodAddImageCell.xib
    │   ├── FoodAddSelectCell.swift
    │   ├── FoodAddSelectCell.xib
    │   ├── FoodCategoryCell.swift
    │   ├── FoodCategoryCell.xib
    │   ├── FoodCategoryCollectionViewCell.swift
    │   ├── FoodCategoryCollectionViewCell.xib
    │   ├── FoodCell.swift
    │   ├── FoodCell.xib
    │   ├── FoodCollectionViewCell.swift
    │   ├── FoodCollectionViewCell.xib
    │   ├── FoodOwnerCell.swift
    │   ├── FoodOwnerCell.xib
    │   ├── FoodRemoveRankCell.swift
    │   ├── FoodRemoveRankCell.xib
    │   ├── LoadingReusableView.swift
    │   ├── LoadingReusableView.xib
    │   ├── MemberCollectionViewCell.swift
    │   ├── MemberCollectionViewCell.xib
    │   ├── MemberSearchTableViewCell.swift
    │   ├── MyRefrigeratorTableViewCell.swift
    │   ├── MyRefrigeratorTableViewCell.xib
    │   ├── MypageMenuTableViewCell.swift
    │   ├── NotificationTableViewCell.swift
    │   ├── NotificationTableViewCell.xib
    │   ├── RecipeCategoryTableViewCell.swift
    │   ├── RecipeCategoryTableViewCell.xib
    │   ├── RecipeCollectionViewCell.swift
    │   ├── RecipeCollectionViewCell.xib
    │   ├── RecipeCookingProcessCell.swift
    │   ├── RecipeCookingProcessCell.xib
    │   ├── RecipeDetailCookingProcessCell.swift
    │   ├── RecipeDetailCookingProcessCell.xib
    │   ├── RecipeDetailIngredientCell.swift
    │   ├── RecipeDetailIngredientCell.xib
    │   ├── RecipeIngredientTableViewCell.swift
    │   ├── RecipeIngredientTableViewCell.xib
    │   ├── RefriMemberCollectionViewCell.swift
    │   ├── RefriMemberCollectionViewCell.xib
    │   ├── SelectFridgeTableViewCell.swift
    │   ├── SelectFridgeTableViewCell.xib
    │   ├── SelectedFoodNameCollectionViewCell.swift
    │   ├── SelectedFoodNameCollectionViewCell.xib
    │   ├── WasteCell.swift
    │   └── WasteCell.xib
    ├── DefaultTabBarController.swift
    ├── ViewControllers
    │   ├── Alert
    │   │   ├── Alert.storyboard
    │   │   ├── AlertViewController.swift
    │   │   ├── BaseAlertViewController.swift
    │   │   ├── CompleteBuyingViewController.swift
    │   │   └── InfoAlertViewController.swift
    │   ├── Auth
    │   │   ├── AuthMain.storyboard
    │   │   ├── AuthMainViewController.swift
    │   │   ├── AuthUserInfo.storyboard
    │   │   └── AuthUserInfoViewController.swift
    │   ├── Cart
    │   │   ├── AddFoodViewController.swift
    │   │   ├── Cart.storyboard
    │   │   ├── CartViewController.swift
    │   │   ├── KakaoMapWebViewController.swift
    │   │   └── MapViewController.swift
    │   ├── Food
    │   │   ├── BarCodeAdd.storyboard
    │   │   ├── BarCodeAddViewController.swift
    │   │   ├── BarCodeView.swift
    │   │   ├── FoodAdd.storyboard
    │   │   ├── FoodAddViewController.swift
    │   │   ├── FoodDetail.storyboard
    │   │   ├── FoodDetailViewController.swift
    │   │   ├── SearchFood.storyboard
    │   │   └── SearchFoodViewController.swift
    │   ├── Fridge
    │   │   ├── AddFridgeViewController.swift
    │   │   ├── CategoryFoods
    │   │   │   ├── AllFoodViewController.swift
    │   │   │   ├── DrinkViewController.swift
    │   │   │   ├── ETCViewController.swift
    │   │   │   ├── FruitViewController.swift
    │   │   │   ├── MarineProductsViewController.swift
    │   │   │   ├── MeatViewController.swift
    │   │   │   ├── ProcessedFoodViewController.swift
    │   │   │   ├── SeasoningViewController.swift
    │   │   │   ├── SideViewController.swift
    │   │   │   └── VegetableViewController.swift
    │   │   ├── FoodAddSelect.storyboard
    │   │   ├── FoodAddSelectViewController.swift
    │   │   ├── Fridge.storyboard
    │   │   ├── FridgeViewController.swift
    │   │   └── SelectFrideViewController.swift
    │   ├── Graph
    │   │   ├── ConsumeGraph.storyboard
    │   │   ├── ConsumeGraphViewController.swift
    │   │   ├── GraphMain.storyboard
    │   │   ├── GraphMainViewController.swift
    │   │   ├── WasteGraph.storyboard
    │   │   └── WasteGraphViewController.swift
    │   ├── MyFridge
    │   │   ├── EditMyFridgeViewController.swift
    │   │   ├── MyRefrigerator.storyboard
    │   │   └── MyRefrigeratorViewController.swift
    │   ├── MyPage
    │   │   ├── MyPage.storyboard
    │   │   ├── MyPageViewController.swift
    │   │   └── PolicyWebViewController.swift
    │   ├── Notification
    │   │   ├── Notification.storyboard
    │   │   └── NotificationViewController.swift
    │   ├── Recipe
    │   │   ├── AddRecipeSecondViewController.swift
    │   │   ├── AddRecipeViewController.swift
    │   │   ├── BookmarkRecipeViewController.swift
    │   │   ├── Category
    │   │   │   ├── PopularRecipeViewController.swift
    │   │   │   └── RecipeInFridgeViewController.swift
    │   │   ├── MyRecipeViewController.swift
    │   │   ├── Recipe.storyboard
    │   │   ├── RecipeDetailViewController.swift
    │   │   ├── RecipeSearchViewController.swift
    │   │   └── RecipeViewController.swift
    │   └── Refrigerator
    │       ├── Refrigerator.storyboard
    │       ├── RefrigeratorAdd.storyboard
    │       ├── RefrigeratorAddViewController.swift
    │       ├── RefrigeratorTabMan.swift
    │       └── RefrigeratorViewController.swift
    └── ViewModel
        ├── Auth
        │   └── AuthViewModel.swift
        ├── Cart
        │   └── CartViewModel.swift
        ├── Food
        │   └── FoodViewModel.swift
        ├── Fridge
        │   └── FridgeViewModel.swift
        ├── Graph
        │   └── GraphViewModel.swift
        ├── MyFridge
        │   └── MyRefrigeratorViewModel.swift
        ├── Recipe
        │   └── RecipeViewModel.swift
        └── User
            └── UserViewModel.swift
```
<br>
</details>
<br><br>


## iOS Architecture 
<details>
<summary>MAIN_SERVER</summary>
 
![image](https://github.com/IceButler/IceButler_Server/assets/90203250/de9db769-11c5-45e7-8c6a-5f861bb5ff19)
    
<br>
</details>
<details>
<summary>RECIPE_SERVER</summary>

![image](https://github.com/IceButler/IceButler_Server/assets/90203250/2f76bbac-2e7b-433e-b127-e592c700ef2d)

<br>
</details>
<br><br>

<br>

## Commit/PR Convention
**Commit**
```
#1 feat: 일정 등록 API 추가
```
- #이슈번호 타입: 커밋 설명
<br>

**Pull Request**
```
[feature/1-create-calender] 일정 등록
```
- [브랜치명]  설명
<br>

## Branch Strategy
- main
    - 배포 이력 관리 목적
- develop
    - feature 병합용 브랜치
    - 배포 전 병합 브랜치
- feature
    - develop 브랜치를 베이스로 기능별로 feature 브랜치 생성해 개발
- test
    - 테스트가 필요한 코드용 브랜치
- fix
    - 배포 후 버그 발생 시 버그 수정 
<br>

- feature branch의 경우, 기능명/이슈번호-기능설명 형태로 작성
```md
feature/7-desserts-patchDessert
```
<br>

<br>
<br>

## Member
|[김나연](https://github.com/Nya128)|[김초원](https://github.com/ryr0121)|[차유상](https://github.com/chayoosang)|[냉집사](https://github.com/IceButler)|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Nya128.png" width="180" height="180" >|<img src="https://github.com/ryr0121.png" width="180" height="180" >|<img src="https://github.com/chayoosang.png" width="180" height="180" >|<img src="https://github.com/IceButler.png" width="180" height="180">|
| **iOS Developer** | **iOS Developer**| **Architect & <br> iOS Developer**| **ICE BUTLER** |
