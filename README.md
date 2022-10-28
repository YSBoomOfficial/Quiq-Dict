# Quiq-Dict
A Minimal Dictionary App build with UIKit

## Screenshots
| Search Screen | Detail Screen |
| --- | --- |
| ![You Win](https://github.com/YSBoomOfficial/Quiq-Dict/blob/main/App%20Screenshots/SearchHello.png) | ![You Win](https://github.com/YSBoomOfficial/Quiq-Dict/blob/main/App%20Screenshots/HelloDetail.png) |

## Dictionary API
For more information about the API used in this app see [dictionaryapi.dev](https://dictionaryapi.dev/)

## Additional Info
### How was it built?
- UIKit (Programatic UI with AutoLayout)
- MVC Architecture
- URLSession and Swift Result Type for Networking
- User’s Documents Directory for local storage
- Not 3rd party libraries

### focus areas
- Reduce tight coupling
- Making the app testable
- make ViewControllers Reusable

### Lessons I learned
1. Don’t make unnecessary abstractions that you ‘think’ you’ll need later on
	- When I started working on the app I tried to make unnecessary abstractions and add unnecessary features to the Networking layer that didn’t really need (eg: FallbackService, RetryFeature etc). 


2. Have a clear plan before trying to build out a feature 
	- This lead to me going back on some decisions when trying to make the detail view 
