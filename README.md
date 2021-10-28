# Prog2WeatherProject

A weather forecast app written in Swift using SwiftUI, firstly for iOS, later for iPadOS. The app uses [OpenWeaterMap](https://openweathermap.org/api) and [LocationIQ](https://locationiq.com/) API's data.

## Made on

- MacOS 11.6 Big Sur
- Xcode 13
- iOS 15
- Swift 5.5

## APIs

To run the app you need two API keys. You can get them [here](https://locationiq.com/pricing) and [here](https://openweathermap.org/price).  

### Rate Limit

| OpenWeatherMap | LocationIQ |
| ----------- | ----------- |
| 1.000.000 requests /month | 5000 requests /day |
| 60 requests /minute | 2 requests /second |

### Config

You need a `config.json` file which contains both of your API keys.

Example:
```json 
{
    "openWeatherAppId": "Your openweathermap.org app id",
    "locationApiKey": "Your locationiq.com api key",
}
```
