---
author: Kolyn090
banner: /static/img/svz/read-digit-banner.png
categories: Tutorial
custom_class: custom-page-content
date: 2025-02-13 20:00:00 -0500
layout: post
permalink: /svz-read-digits/
theme: sushi
title: Reading level progress and leadership
---


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: Tutorial


Platform: Windows


Prerequisite: Basic Python, read [this article](/svz-player-hp/) and [this article](/svz-pachinko-coins/)


## Introduction
Today we will continue making the battle AI for game SvZ Defense. In this tutorial I will teach you how to read the level progress and leadership from game screenshots.


![samurai-level-progress](/static/img/svz/samurai-level-progress.png)


*Level progress (Samurai side)* We want to read number 0 from this image.


![samurai-leadership](/static/img/svz/samurai-leadership.png)


*Leadership (Samurai side)* We want to read number 2 from this image.


![zombie-level-progress](/static/img/svz/zombie-level-progress.png)


*Level progress (Zombie side)* We want to read number 0 from this image.


![zombie-leadership](/static/img/svz/zombie-leadership.png)


*Leadership (Zombie side)* We want to read number 6 from this image.


## Observation
The very first thing we notice is that the font and typeface of the digits are the same. This means that it's a good situation to apply template matching technique. 


Things are looking very similar as the reading coins amount problem. Except that in the coins amount the numbers are clearly white-background-black-text. 


![pachinko-digits](/static/img/svz/pachinko-digits.png)


![pachinko-digits2](/static/img/svz/pachinko-digits2.png)


where in this case the backgrounds are non-solid and the text have white or black color. 


![samurai-level-progress](/static/img/svz/samurai-level-progress.png)


![samurai-level-progress2](/static/img/svz/samurai-level-progress2.png)


![samurai-leadership](/static/img/svz/samurai-leadership.png)


![samurai-leadership2](/static/img/svz/samurai-leadership2.png)


![zombie-level-progress](/static/img/svz/zombie-level-progress.png)


![zombie-level-progress2](/static/img/svz/zombie-level-progress2.png)


![zombie-leadership](/static/img/svz/zombie-leadership.png)


![zombie-leadership2](/static/img/svz/zombie-leadership2.png)


If we could come up with some way to convert them to white-background-black-text, we should be able to apply the same algorithm again to read the digits.


