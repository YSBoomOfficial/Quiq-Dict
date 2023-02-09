# Quiq-Dict
## Table Of Contents
1. [What is it](#what-is-it)
2. [How was it built?](#how-was-it-built)
3. [Focus areas for personal development](#focus-areas-for-personal-development)
4. [Alternatives and Future directions](#alternatives-and-future-directions)
5. [Lessons I learned](#lessons-i-learned)
6. [Screenshots and App Walkthrough](#screenshots-and-app-walkthrough)


## What is it?
- Quiq Dict is a minimal dictionary App
- Quickly search for words and get back detailed information including definitions, synonyms, antonyms, example sentences, phonetic transcriptions and audio examples.
- Save Words and their related information for offline access

## How was it built?
- UIKit (Programatic UI with AutoLayout)
- MVC Architecture
- URLSession and Swift Result Type for Networking
	- For more information about the API used in this app see [dictionaryapi.dev](https://dictionaryapi.dev)
- User’s Documents Directory for local storage
- No 3rd party libraries

## Focus areas for personal development
- Reduce tight code coupling (eg: using DI)
- Making the app easy to test (eg: Making types easy to mock using protocols)
- make ViewControllers Reusable
- Extracting components of larger views into smaller views
- Unit Tests and UI Tests

## Alternatives and Future directions
- MVVM: 
	- I experimented with MVVM in the very early stages of the app (before making the detail screen) but decided to go back to MVC as I didn’t ‘need’ it at that time. The app could adopt MVVM in the future to avoid having to do a lot of formatting in the detail View.

- Coordinators:
	- At the moment the app is using `show(_:sender:)` for navigation. I considered implementing coordinators, although, given that the app only needs to navigate between 2 screens for now, the coordinator pattern doesn’t really provide much benefit. Although this could be a good future direction to further decouple navigation logic.

- Saved data in a better way and sharing it across devices
	- Currently I’m writing the data to the user’s documents directory as a JSON file and mp3 for audio files. Although, I think it would be better in the long run to save the data to Core Data which would then enable syncing of data across devices.

## Lessons I learned
1. Don’t make unnecessary abstractions that you ‘think’ you’ll need later on
	- When I started working on the app I tried to make unnecessary abstractions and add unnecessary features to the Networking layer that didn’t really need (eg: Fallback Service, Retry Request etc). 

2. Have a clear plan before trying to build out a feature 
	- This lead to me going back on some decisions. eg: When I was first trying to make the detail view I used a `UITableView` and a single `UITableViewCell`. I attempted to make something similar with a `UIScrollView` and a `UIStackView` but it didn’t function how I wanted it to so I reverted to the old implementation.

## Screenshots and App Walkthrough
| App Walkthrough |
| --- |
| ![Search Screen](https://github.com/YSBoomOfficial/Quiq-Dict/blob/main/App%20Screenshots/AppUsage.gif) |

| Search Screen | Detail Screen |
| --- | --- |
| ![Search Screen](https://github.com/YSBoomOfficial/Quiq-Dict/blob/main/App%20Screenshots/SearchHello.png) | ![Detail Screen](https://github.com/YSBoomOfficial/Quiq-Dict/blob/main/App%20Screenshots/HelloDetail.png) |
