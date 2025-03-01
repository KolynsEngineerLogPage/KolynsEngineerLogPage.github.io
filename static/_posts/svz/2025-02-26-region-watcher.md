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


# Step 1
As usual, we will add a new folder that contain the structure of today's code. Add a new folder `region_watchers` under `ai`.
{% highlight python %}
ai
|___ player_hp
|    |___ ...
|___ read_digit
|    |___ ...
|___ read_cd
|    |___ ...
|___ region_watchers
|    |___ debug
|    |___ templates
|    |___ pause_watcher.py
|    |___ region_watcher.py
|___ config.toml
|___ ui_position.py
{% endhighlight %}

Here, I used the world "watcher" instead of "observer". They mean the same thing.

---

Next add the following line in `ui_position.py`.
{% highlight python %}
pause_bound = [12, 44, 69, 79]
{% endhighlight %}
This is the bound for the pause button in battle mode. Yours could be different. If that's the case you can use `mouse_coordinates.py` to get the correct bound. The expected image is below.


![pause](/static/img/svz/pause.png)


Now drag the above image under the `templates` folder.

---

I have provided a testing image this time as well. Drag this image under `debug` folder.


![battle_scene](/static/img/svz/battle_scene.png)

<br>
🎉 Now that the preparation works are done, we can get into making a region watcher.


# Step 2
In `region_watcher.py`, add
{% highlight python %}
import cv2
import time
import threading
import numpy as np
from src.util.screen_getter import get_chosen_region_cv2


class Region_Watcher:
    def __init__(self, window, template_path: str,
                 region_bound, interval: float, callback,
                 threshold: float, name: str):
        self._window = window
        self._template = cv2.imread(template_path, cv2.IMREAD_UNCHANGED)
        self._region_bound = region_bound
        self._has_begun = False
        self._threshold = threshold
        self.debug = False
        self.name = name

        def work():
            while True:
                if self._has_begun and self._trigger():
                    callback()
                time.sleep(interval)

        self._thread = threading.Thread(target=work)
{% endhighlight %}
🤓 It looks like we have a lot things going on here. Don't worry, let me explain... First of all, the parameters. `window` is the emulator window. `template_path` is the path to the template. `region_bound` is the bound to be observed. `interval` is the time interval for which a check is performed. `callback` is a function that is called after the program noticed a change in the observing area. `threshold` is the tolerance of the observation. This makes sure that it won't react to some tiny changes. `name` is the name of this observer. This is for debugging purposes. 


The next important thing is the `work()` function. This is the function that performs checks every x times. We put it in a thread and it will continuously do its job until it's been told to stop.

---

Next, add the following in `Region_Watcher` class.
{% highlight python %}
def begin(self):
    self._has_begun = True
    self._thread.start()

def is_match(self):
    return self._trigger()
{% endhighlight %}

---

Here is the `trigger()` function.
{% highlight python %}
def _trigger(self):
    region = get_chosen_region_cv2(self._window, self._region_bound)
    if self.debug:
        cv2.imwrite(f'debug/{self.name}.png', region)
    return self._exists_template_rgb(self._template, region, self._threshold)
{% endhighlight %}

Actually, let's make a small change in this so that we use the testing example. (This is for testing and we'll come back later to change this.)

{% highlight python %}
def _trigger(self):
    # region = get_chosen_region_cv2(self._window, self._region_bound)
    region = cv2.imread('debug/battle_scene.png', cv2.IMREAD_UNCHANGED)
    if self.debug:
        cv2.imwrite(f'debug/{self.name}.png', region)
    return self._exists_template_rgb(self._template, region, self._threshold)
{% endhighlight %}

---

Finally, add this function in `Region_Watcher`.
{% highlight python %}
@staticmethod
def _exists_template_rgb(template, image, threshold=0.97):
    if template.shape != image.shape:
        raise ValueError("Images must have the same dimensions for comparison.")

    # compute Mean Squared Error (MSE)
    mse = np.mean((template.astype(np.float32) - image.astype(np.float32)) ** 2)

    # normalize to range [0,1], where 1.0 means identical
    similarity = 1 - (mse / (255 ** 2))

    return similarity > threshold
{% endhighlight %}
I hope you'll find this function sound familiar because we have already discussed MSE (mean squared error) [before](/svz-pachinko-coins/). This is the exact same idea but this time the range of the final result is [0, 1]. We'll be using this function to check if any change has occurred.


<br>
🎉 Well done. Now we have a general region watch that can work in many scenarios.


# Step 3
Now, this last step is to create the region watcher for pause button. Add the following in `pause_watcher.py`.
{% highlight python %}
import os
from src.ai.ui_position import pause_bound
from src.ai.region_watchers.region_watcher import Region_Watcher
from src.util.screen_getter import get_window_with_title


class Pause_Watcher(Region_Watcher):
    def __init__(self, window, callback, interval=1):
        script_dir = os.path.dirname(os.path.abspath(__file__))
        super().__init__(window, os.path.join(script_dir, 'templates/pause.png'),
                         pause_bound, interval, callback, 0.97, 'pause_region')

if __name__ == '__main__':
    def work():
        print('Is in battle.')

    pause_watcher = Pause_Watcher(None, work)
    pause_watcher.debug = True
    pause_watcher.begin()
{% endhighlight %}

After you run this code and stop, you should see a new debug image that look exactly to your pause button template.


![pause_region](/static/img/svz/pause.png)


Also, you should see this message every second.
{% highlight cmd %}
Is in battle.
{% endhighlight %}
You can change this to other values. Or, like said before, 5 is a good value.

---

If you got this to work, now you can put this to the actual emulator test.

First of all, change the driver code to
{% highlight python %}
if __name__ == '__main__':
    chosen_window = get_window_with_title('BlueStacks App Player')

    def work():
        print('Is in battle.')

    pause_watcher = Pause_Watcher(chosen_window, work)
    pause_watcher.debug = True
    pause_watcher.begin()
{% endhighlight %}


Next change the `trigger()` back to reading screenshot from emulator window.
{% highlight python %}
def _trigger(self):
    region = get_chosen_region_cv2(self._window, self._region_bound)
    if self.debug:
        cv2.imwrite(f'debug/{self.name}.png', region)
    return self._exists_template_rgb(self._template, region, self._threshold)
{% endhighlight %}


Very good, now open the emulator and play SvZ Defense and run this program. See if your program prints "Is in battle." only in the battle mode. If not, look back and check if you have missed anything in this tutorial. Or if your observing bound and the template are really matching.

<br>
🎉 Excellent, now we can observe whether we are in the battle mode. This is going to be useful for our model's training. 


<br>
<br>
🍯 Happy Coding 🍯


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**
