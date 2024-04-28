# Project - *TablePlay*

Submitted by: **Nasif Zaman**

A ipadOS table top game viewer for real game data. You can walk around the field and enjoy the game from any angle you like.

Time spent: **5** hours spent in total

##Wireframe:

[![Wireframe](https://github.com/Znasif/TablePlay/blob/main/TablePlayiOS/wireframe.png?raw=true)](https://github.com/Znasif/TablePlay/blob/main/TablePlayiOS/Wireframe.pdf)

## Required Features

The following functionality is underway:

- [x] Create a json with play data and folder structure
- [x] App displays a list of past sports sorted by most recent

The following **additional** features are implemented:

- [x] Users can pick one sport from list and they will be taken to an AR screen
- [x] User can select a rectangular surface that will be selected as the field for player population
  - [] Note: Plan to do a visionOS version
- [x] The field is anchored to the table
- [x] Players and football/basketball etc are anchored to the field
- [x] animations work properly   

# Video Walkthrough

### Final Sprint
[![Final Sprint](https://img.youtube.com/vi/P-9zfeBjji8/0.jpg)](https://www.youtube.com/watch/P-9zfeBjji8)

### Second Sprint
[![Second Sprint](https://img.youtube.com/vi/pKdX7K87USY/0.jpg)](https://www.youtube.com/watch/pKdX7K87USY)

### First Sprint
[![First Sprint](https://img.youtube.com/vi/ZBwPsIC9hjA/0.jpg)](https://www.youtube.com/watch/ZBwPsIC9hjA)

### 2D version
[![2D version](https://img.youtube.com/vi/eyO3FTeX5TI/0.jpg)](https://www.youtube.com/watch/eyO3FTeX5TI)

### 3D version
[![3D version](https://img.youtube.com/vi/Qftx7mHzXO8/0.jpg)](https://www.youtube.com/watch/Qftx7mHzXO8)

### 3D Nearer version
[![3D Nearer version](https://img.youtube.com/vi/Sq2xhPU1kQk/0.jpg)](https://www.youtube.com/watch/Sq2xhPU1kQk)


## Challenges Faced and Resolved

The following challenges were faced:

- [x] keep the anchor attached to a real-world plane (detach and attach from entities)
- [x] have the different player cubes move around the field when the field is attached to a plane.
- [x] load realistic player and football mesh
- [x] animate using locomotion data including orientation

The following challenges remain:

- [] allow multiple fields to be attached at the same time in different locations so that all can be viewed together
- [] allow plays to be favorited/ teams to be favorited (have this data persist)
- [] allow player pose animation
- [] show kickoff and penalty events as 3D text

## License

    Copyright [2024] [Nasif Zaman]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
