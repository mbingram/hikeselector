# HIKESELECTOR Technical Documentation
HIKESELECTOR is a Command Line Interface (CLI) application that allows a user to login, view hikes, and keep a list of favorite hikes. 
 

## SUMMARY
Hiking is a popular activity for Colorado Residents. Choosing a hike can be more work than going on the hike itself! Skip the agonizing and use HIKESELCTOR. This app allows a user to login with a 

#### BACKGROUND INFORMATION

Hike Filters
  *Location
   -String of "City, ST" 
  *Dog Friendly?
    -Boolean of true (dog friendly) or false (not dog friendly)
  *Elevation Gain
    -Integer of total elevation gain over the hike in miles
  *Difficulty
    -String of one of three options ("Beginner", "Intermediate", "Advanced")
  *Distance
    -Integer of total distance of the hike in miles

Data for hikes were seeded by the developers and feature hikes near the front range of Denver, CO. 
Future iterations could include a call to an appropriate API to seed more hike information in the database. 

##### TECHNOLOGY
This app was created using ruby, ActiveRecord, and TTY-Prompt.
