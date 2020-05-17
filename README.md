![MacPawCatsAppIcon](MacPawCats/Resources/Assets.xcassets/AppIcon.appiconset/100.png)
# MacPawCats
MacPawCats is a test task for MacPaw 2020 Summer Internship.
Hello fellow whoever reads this. For my test task i thought i'd mix some of my favourite timekilling apps (reddit+insta) with TheCatApi for the ultimate cat browsing experience. During the development of this test assignment i've tried a couple of new things and approaches here and there(might have not implemented them perfectly).

## Tech parameters
iOS 13.0+, Swift, MVVM+Coordinator.
## Implemented Features
- Login (login-like screen)
- Onboarding
- Feed (with options of searching & filtering cat images by (category/breed) & order & type, up/DownVoting & "fav"'ing images)
- Image Upload
- Profile

**Features:**

![Login-Onboarding](MacPawCats/Resources/Gifs/Login-Onboarding.gif) ![Feed1](MacPawCats/Resources/Gifs/Main1.gif)
![Feed2](MacPawCats/Resources/Gifs/Main2.gif) ![Other](MacPawCats/Resources/Gifs/Other.gif)

## Features TOADD
MacPawCats is far from "perfect". I thought i'd list some features that could've been added/improved if no "The application should not use third-party dependencies" rule and TheCatApi limitations.
- **GIF support**. There are a ton of cat gifs on TheCatApi(and who doesn't like cat gifs huh?), unfortunately (as far as i know and researched) there is currently no native iOS Gif support.
- Proper networking layer
- Better image filtration UI (some custom one instead of pickerView, looks kinda old)
- Image chaching/clearing mechanism (once you load al lot of images, app becomes heavy on memory)
- Proper like/fav showing mechanism (can't be currently implemented cause TheCatApi doesn't return any Fav/Vote objects with image in any of the requests. This feature might be implemented soon as it's recently been requested on TheCatApi forums.)

I might update/add something so stay tuned ;)
