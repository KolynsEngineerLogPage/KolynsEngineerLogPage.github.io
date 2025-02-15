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


## The Plan
Fair warning: this is going to be more difficult than it looks. Please be patient and follow each step carefully as you move on.

1 . The first thing we want to do is actually quantize the image (reduce the number of colors). If we got lucky we might even make the background completely solid after this step.


![progress_quantize_samurai](/static/img/svz/progress_quantize_samurai.png)
![progress_quantize_zombie](/static/img/svz/progress_quantize_zombie.png)
![leadership_quantize_samurai](/static/img/svz/leadership_quantize_samurai.png)
![leadership_quantize_zombie](/static/img/svz/leadership_quantize_zombie.png)


2 . Since we only care about the black and white colors, in this step we can enhance the black and white colors in our images. After enhancing them intensively we will get something like:


![progress_enhance_samurai](/static/img/svz/progress_enhance_samurai.png)
![progress_enhance_zombie](/static/img/svz/progress_enhance_zombie.png)
![leadership_enhance_samurai](/static/img/svz/leadership_enhance_samurai.png)
![leadership_enhance_zombie](/static/img/svz/leadership_enhance_zombie.png)


3 . We only want to work with white-background-black-text images. After the last step our images are mostly black, white, and gray. Therefore we can just invert the color for the black-background-white-text images. 


![progress_converted_samurai](/static/img/svz/progress_converted_samurai.png)
![progress_converted_zombie](/static/img/svz/progress_converted_zombie.png)
![leadership_converted_samurai](/static/img/svz/leadership_converted_samurai.png)
![leadership_converted_zombie](/static/img/svz/leadership_converted_zombie.png)


4 . Convert the images to binary and we will end up with something very similar to before.


![progress_binary_samurai](/static/img/svz/progress_binary_samurai.png)
![progress_binary_zombie](/static/img/svz/progress_binary_zombie.png)
![leadership_binary_samurai](/static/img/svz/leadership_binary_samurai.png)
![leadership_binary_zombie](/static/img/svz/leadership_binary_zombie.png)


5 . On this point forward, we will work with the blobs again but we can't just yet apply the algorithm we have from before. We will want to make sure that the digits blobs are not broken and remove all blobs that are just noises. It doesn't benefit your understanding to explain them here so I will put them in the later parts of the tutorial.


6 . Now we have met every requirement. Apply the template matching algorithm and read the digits.


