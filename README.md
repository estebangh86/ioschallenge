# Knomatic iOS Code Challenge
This repo contains the Knomatic iOS code challenge.

## Task
Your task is to write a small iOS universal app so that it tells the current and forecast weather at the user's location.  You will need to get the user's location and then use that to contact the [Dark Sky Forecast API](https://developer.forecast.io/) and display the weather and forecast. After that is completed, please complete the questionnaire at the bottom of this readme file.  Please include your answers inline in this file.

Your time is valuable and we understand that.  Our goal is for you to spend about three hours working on this task.  If you are having fun and want to take it farther feel free, but it's not required. Our evaluation criteria are listed below.  Please make sure that all of the evaluation sections are included.  And to be clear we don't expect them to be 100% production ready, just enough to show that you know what you're doing in each area.

**_A note about the Dark Sky Forecast API Key_**:
[The Dark Sky Forecast API](https://developer.forecast.io/) has free tier that allows about 1000 calls a day, you can sign up for an API key today without giving them any payment details.  If this changes or you have a problem, please email us and we will get you an API key.

## Requirements
- You must finish this application so that it can contact the [Dark Sky Forcast API](https://developer.forecast.io/) for the users location, and display the current weather and the forcast.
- Your submission must be a fork of this repo and a submitted as a pull request on GitHub
- You should add any needed screens/UI elements
- You should support various screen sizes and resolutions of iPad and iPhone
- You must answer the questions inline in this file.

## Notes and Hints
- You may use Swift or Objective-C as your programming language
- You may use any other open source libraries you want
- Its nice when things look nice, but we know you're not a designer.  A set of weather icons can be found here: http://adamwhitcroft.com/climacons/ and design mocks for iPhone and iPad of our weather screen are included in this repo at /mock_iphone.png and /mock_ipad.png respectively. Your app dosn't need to look like the mock, its just for inspiration to help get you started.

## Evaluation
- Setup for universal app
- Dependency management
- Layout
- Network
- JSON
- Location

## Bonus Points
- Some working unit tests!

## Questions to Answer
Please answer the following in about a paragraph.

1.  How long did you spend on completing this challenge?
- 7 hours
2.  How far were you at 3 hours?
- Basic implementation takes less than 3 hours, unexpected dependency problems and UI tuning may take way longer...
3.  What needs to be finished/fixed for this to be use in a production app?
- Modularize location, API and info formatting components; some additional logic for location acquisition, setting configs on Dev center and configuration of provisioning and app signing (certificates)
4.  What did you think of this challenge?
- It's great for testing some layout and interface orientation problems
5.  What part was unclear?
- Persistence may not be mandatory, although some caching on location lookup may be revised. There's a green indicator without a clear purpose.
6.  What could we do to make this challenge better?
- Figuring out a way to enforce persistence and maybe adding another service to be consumed by the background image
7.  What did we forget to test you on?
- Media handling, some concurrency like GCD and operation queues, persistence, different UI elements like selectors, sliders and pickers; navigation and UI instantiation.
