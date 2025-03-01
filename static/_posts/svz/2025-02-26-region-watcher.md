---
author: Kolyn090
banner: /static/img/svz/region-watcher-banner.png
categories: Tutorial
custom_class: custom-page-content
date: 2025-02-26 10:00:00 -0500
layout: post
permalink: /svz-region-watcher/
theme: sushi
title: Creating a region watcher to observe a given bound
---


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: Tutorial


Platform: Windows


Prerequisite: Basic Python, read [this article](/svz-player-hp/)


## Introduction
Let's resume our "AI" journey (so far what we have been doing are all image processing, but I promise you it's coming to an end). Today we are doing something very simple: <u>observing a given region and call a function when the content in the region has changed.</u> It's like you are staring at the traffic light: you wait when it's red and once it turns green you go. 🚦


Today we will learn how to identify whether the game is in the battle mode by observing the pause button. This is a common strategy in game scripts that identifies the current game mode based on a UI component. Sometime this could be very hard to decide but in this case it's easy, just observe the pause button.


# The Plan
There are two things we need before we start observing. 
1. The observing bound: The area where you want the program to observe.
2. The template: The expected image of the observing area. If your current observing area doesn't match the template then the program will take some actions. (Changes occurred)

Next, we want the program to check every x time. This could be seconds, minutes. In practice, for checking whether the current game mode is battle, 5 seconds is a good value. 


Also, we'll be observing many regions in this project so one good idea is to put this task in another thread. 


To sum up, our tasks are:
1. Obtain the observing bound and template
2. Check a thread to repeat observation every x time

😎 Let's go!


