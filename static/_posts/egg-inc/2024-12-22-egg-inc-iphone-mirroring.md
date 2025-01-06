---
author: Kolyn090
banner: /static/img/egg-inc/egg-inc-ios.png
categories: Log
custom_class: custom-page-content
date: 2024-12-22 17:00:00 -0500
layout: post
permalink: /egg-inc-iphone-mirroring/
theme: egg
title: Auto Prestige with iPhone Mirroring and Python
---

**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: Log


Platform: MacOS


Prerequisite: Basic Python


## Preface
iPhone Mirroring didn’t come to my attention until my friend mentioned it last month. I never imagined it could become the key to conquering iOS devices. All this time, I had been trying to find ways to play games on iOS with scripting, and iPhone Mirroring turned out to be the answer.

## Introduction
Today I have randomly chosen from one of my favorite iOS games and decided to write a script for it, with iPhone Mirroring. It's called [Egg Inc.](https://egg-inc.fandom.com/wiki/Egg,_Inc.) A game where you raise chickens, the chickens lay eggs, and you make profits by shipping the eggs. My goal today will be writing a program specifically for [Prestige](https://egg-inc.fandom.com/wiki/Prestige). 

## The Main Idea
On iPhone Mirroring, mouse clicks will simulate taps on iPhone. This is great because I already know how to simulate clicks and presses and drags. Prestige is a fairly mechanical process—it's repeated over and over, and I have already identified a pattern in it. Basically, this program is going to follow some kind of pattern to perform prestige.

## Limitations
That being said, **if you are here for a one-size-fits-all program, you might be out of luck because this is very experimental.** You will also need at least some degree of knowledge about programming in order to understand the materials presented in this article; and worse, this is a personal log, not a tutorial so I might not be explaining things nicely. 


On the top of that, players have different prestige strategies. I will list mine here.
1. Start from Edible
2. Jump to Dilithium
3. Get enough farm value and jump to Universe
4. Get soul eggs and prestige


Sounds easy? Okay, I admit I've hidden a lot of details. Now I will follow this pattern and build a program based on it.


FYI, my current Earning Bonus and Prestige set:
![earning-bonus-and-prestige-set](/static/img/egg-inc/earning-bonus-and-prestige-set.png)


## The Program
# Step 1
The first thing I am going to do is to open up my new toy iPhone Mirroring.


![new-farm](/static/img/egg-inc/new-farm.png)


Next, I start a new Python project.
![program-hierarchy](/static/img/egg-inc/program-hierarchy.png)


# Step 2
The next thing is to confirm window size and position so that the next time I open this it will be the same. It appears that I cannot change the window size, which is amazing because this means that I would not have to write a `window_rescaler.py` for it. Now I will just put iPhone Mirroring in <u>the top-left corner of my Desktop</u> so my clicks will always occur in the expected positions.


# Step 3
Let's make some clicks. Create `mouse.py` under `interaction`.
{% highlight python %}
import time
import pyautogui


class Mouse:
    def click_pos(self, pos, sleep_time=0.2, once=False):
        x, y = pos
        self.click(x, y, sleep_time, once)

    @staticmethod
    def click(x, y, sleep_time=0.2, once=False):
        pyautogui.click(x, y)
        if not once:
            pyautogui.click(x, y)
        time.sleep(sleep_time)

    @staticmethod
    def perform_drag(drag_from, drag_to, duration=0.5):
        start_x, start_y = drag_from[0], drag_from[1]
        end_x, end_y = drag_to[0], drag_to[1]
        pyautogui.moveTo(start_x, start_y)
        pyautogui.mouseDown()
        pyautogui.dragTo(end_x, end_y, duration=duration, button='left')
        pyautogui.mouseUp() 

    def press_pos(self, pos, duration):
        x, y = pos
        self.click_pos(pos)
        self.press(x, y, duration)

    @staticmethod
    def press(x, y, duration):
        pyautogui.moveTo(x, y)
        pyautogui.mouseDown()
        time.sleep(duration)
        pyautogui.mouseUp()
{% endhighlight %}


Test the code. Here I tried to click on the 'Send Chicken' button.
{% highlight python %}
if __name__ == '__main__':
    mouse = Mouse()
    mouse.click_pos([153, 665])
{% endhighlight %}


🎉 It works!

![send-chicken](/static/img/egg-inc/send-chicken.png)


📍 However, soon I found a problem. It appears that sometimes I have to tap twice on the simulator for the interaction to work and it seems like it's not an issue of focusing. Now things become tricky. That is why I have added a flag `once` to indicate whether this click should be performed only once. By default it performs two.

<br>
That's a good start. Now let's see drags.
{% highlight python %}
if __name__ == '__main__':
    mouse = Mouse()

    drag_from = [70, 540]
    drag_to = [70, 380]
    drag_duration = 1
    mouse.perform_drag(drag_from, drag_to, drag_duration)
{% endhighlight %}


![test-drag](/static/img/egg-inc/test-drag.png)


🎉 Excellent, it has dragged the research menu down. Now I am very certain I have everything needed to control the device.

