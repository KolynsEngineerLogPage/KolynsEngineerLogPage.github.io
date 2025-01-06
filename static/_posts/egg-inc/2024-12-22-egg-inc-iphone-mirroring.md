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

## Very Important
⚠️ I have omitted many details that are not directly related. In the future I <u>might</u> make write another log about them. **Please do not be surprised if things are not working well after you have followed everything in this blog.** Also, please do not have high hope about this, even after optimizations, its efficiency is still horrible compared to manual prestige.

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

---

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

# Step 4
In this step I will create some utility scripts.


I imagine it's going to have massive logs so I will need a class that can generate and store the logs. Create `logger.py` under `log`.
{% highlight python %}
import os
import fnmatch

script_dir = os.path.dirname(os.path.abspath(__file__))
logs_path = os.path.join(script_dir, 'logs')


class Logger:
    def __init__(self):
        self._content = []

    def add_content(self, line):
        self._content.append(line)

    def save_content(self):
        os.makedirs('logs', exist_ok=True)
        new_save_path = self.get_new_save_path()
        with open(new_save_path, 'w') as file:
            file.write("\n".join(self._content))

    @staticmethod
    def get_new_save_path():
        prefix_name = 'log'
        max_num = 0
        for dirpath, dirnames, filenames in os.walk(logs_path):
            for filename in fnmatch.filter(filenames, '*.txt'):
                num = int(filename.replace(prefix_name, '').replace('.txt', ''))
                if num > max_num:
                    max_num = num
        return os.path.join(logs_path, prefix_name + str(max_num + 1) + '.txt')


if __name__ == '__main__':
    logger = Logger()
    print(logger.get_new_save_path())
    logger.add_content('test')
    logger.add_content('test2')
    logger.save_content()
{% endhighlight %}


As expected.


![log-test](/static/img/egg-inc/log-test.png)

---

Now create a base class that takes-in and is initialized with a `Logger`. Everything worth logging must inherit from this class. Create `debug_class` under `program`.
{% highlight python %}
from src.log.logger import Logger


class Debug_Class:
    def __init__(self, logger: Logger):
        self._debug = False
        self._logger = logger

    def message(self, content):
        if self._debug:
            print(content)
            self._logger.add_content(content)

    def set_verbose(self):
        self._debug = True

{% endhighlight %}

---

Next would be `mouse_coordinate.py` under `util`. 
{% highlight python %}
from pynput import *


def get_coords(x, y):
    print("Now at: {}".format((x, y)))


if __name__ == '__main__':
    with mouse.Listener(on_move=get_coords) as listen:
        listen.join()
{% endhighlight %}
🤓 This script gets the current position of the mouse. I use this to get the positions of the UI.

---

Although I don't know where I can apply this yet, I am fairly sure I am going to need to take screenshots. Let me copy & paste some old code from my screen-scraping projects. Create `window_getter.py` under `util`.
{% highlight python %}
import platform
if platform.platform().startswith('macOS'):
    import Quartz
import PIL.ImageGrab


def get_window_with_title(title):
    def get_window_list_mac():
        window_list = []
        window_info_list = Quartz.CGWindowListCopyWindowInfo(Quartz.kCGWindowListOptionOnScreenOnly,
                                                             Quartz.kCGNullWindowID)
        for window_info in window_info_list:
            window_list.append(window_info)
        return window_list

    def get_mac_windows():
        result = []
        for m_window in get_window_list_mac():
            m_window_title = m_window.get('kCGWindowOwnerName', 'No Title')
            if title in m_window_title:
                result.append(m_window)
        return result

    if platform.platform().startswith('macOS'):
        windows = get_mac_windows()
        if len(windows) > 0:
            return windows[0]
    else:
        return None


def get_screen_of_chose_window(chosen_window):
    def run_mac():
        bounds = chosen_window.get('kCGWindowBounds')
        h = int(bounds.get('Height'))
        w = int(bounds.get('Width'))
        x = int(bounds.get('X'))
        y = int(bounds.get('Y'))
        return PIL.ImageGrab.grab(bbox=(x, y, w+x, h+y),
                                  include_layered_windows=True,
                                  all_screens=True)
    if platform.platform().startswith('macOS'):
        return run_mac()
    else:
        return None
{% endhighlight %}


Tests.
{% highlight python %}
if __name__ == '__main__':
    chosen_window = get_window_with_title('iPhone Mirroring')
    print(chosen_window)
    get_screenshot_of_chosen_window(chosen_window).save('screenshot-test.png')

{% endhighlight %}


I got

{% highlight shell %}
{
    kCGWindowAlpha = 1;
    kCGWindowBounds =     {
        Height = 694;
        Width = 312;
        X = 0;
        Y = 25;
    };
    kCGWindowIsOnscreen = 1;
    kCGWindowLayer = 0;
    kCGWindowMemoryUsage = 2272;
    kCGWindowName = "iPhone Mirroring";
    kCGWindowNumber = 6958;
    kCGWindowOwnerName = "iPhone Mirroring";
    kCGWindowOwnerPID = 11641;
    kCGWindowSharingState = 1;
    kCGWindowStoreType = 1;
}
{% endhighlight %}

and

![screenshot-test](/static/img/egg-inc/screenshot-test.png)


Let me do just these 3 for now.


# Step 5
Now, after I have performed a prestige manually. I think here are the parts I need to implement.
- depot - upgrade trucks
- egg_jump
- house - upgrade houses
- prestige
- research
- spawner - spawn chickens


Put them under `play`


![play-folder](/static/img/egg-inc/play-folder.png)


Also, create `ui_position` under each of them.
![play-folder2](/static/img/egg-inc/play-folder2.png)


In the following steps, my job will be implementing all of them and in the end I will use everything together to write the final prestige machine in `main.py`.


# Step 6
Finally I am going to implement something related to the game. Let me start with the first thing every player does in the game - spawn chickens. 


In `spawner/ui_position.py`, put


{% highlight python %}
spawn_pos = [153, 665]
{% endhighlight %}


Create `spawner.py` under `spawner`.
{% highlight python %}
import time
from src.interaction.mouse import Mouse
from src.play.spawner.ui_position import spawn_pos
from src.program.debug_class import Debug_Class


class Spawner(Debug_Class):
    def __init__(self, logger):
        super().__init__(logger)
        self._mouse = Mouse()

    async def spawn_chicken(self, duration=2):
        self.message(f"Spawn chicken for {duration} seconds.")
        self._mouse.click_pos(spawn_pos)
        self._mouse.press_pos(spawn_pos, duration)
        self.message(f"Resting for {round(duration * 0.75, 2)} seconds.")
        time.sleep(duration * 0.75)
{% endhighlight %}
🤓 `spawn_chicken` sends chickens for `duration` seconds and release for `duration * 0.75` seconds.


Now test this.
{% highlight python %}
import asyncio
from src.log.logger import Logger

async def main():
    logger = Logger()
    spawner = Spawner(logger)
    await spawner.spawn_chicken(10)

if __name__ == '__main__':
    asyncio.run(main())
{% endhighlight %}


![spawn-test](/static/img/egg-inc/spawn-test.png)


I can even make this go on forever.
{% highlight python %}
async def spawn_continue(self, times=5, duration=2):
    self.message(f"Spawn {times} waves of chicken.")
    for i in range(times):
        self.message(f"Perform spawn wave {i + 1}.")
        await self.spawn_chicken(duration)
{% endhighlight %}


Test.
{% highlight python %}
import asyncio
from src.log.logger import Logger

async def main():
    logger = Logger()
    spawner = Spawner(logger)
    await spawner.spawn_continue(5, 5)

if __name__ == '__main__':
    asyncio.run(main())
{% endhighlight %}

![spawn-test2](/static/img/egg-inc/spawn-test2.png)


🎉 This should be everything about spawn chickens.


# Step 7
The next easiest thing to do is to purchase chicken houses. Create `house.py` under `house`.
{% highlight python %}
from src.interaction.mouse import Mouse
from src.program.debug_class import Debug_Class
from src.play.house.ui_position import (house_pos,
                                        max_pos1,
                                        max_pos2,
                                        max_pos3,
                                        max_pos4,
                                        exit_pos)

class House(Debug_Class):
    def __init__(self, logger):
        super().__init__(logger)
        self._mouse = Mouse()

    async def buy_new_house(self):
        # go to purchasing house menu
        # click multiple times (to prevent drones)
        self.message("Open house menu.")
        self._mouse.click_pos(house_pos, 0.7)
        self._mouse.click_pos(house_pos, 0.7)
        self._mouse.click_pos(house_pos, 0.7)

        # max out houses
        self._mouse.click_pos(max_pos1)
        self._mouse.click_pos(max_pos2)
        self._mouse.click_pos(max_pos3)
        self._mouse.click_pos(max_pos4)

        self.message("Purchased houses.")

        # exit
        self.message("Close menu.")
        self._mouse.click_pos(exit_pos, 0.7)

{% endhighlight %}


Add the following to `house/ui_position.py`.
{% highlight python %}
house_pos = [183, 227]

max_pos1 = [121, 363]
max_pos2 = [223, 312]
max_pos3 = [82, 471]
max_pos4 = [223, 471]

exit_pos = [278, 173]
{% endhighlight %}


Test.
{% highlight python %}
import asyncio
from src.log.logger import Logger

async def main():
    logger = Logger()
    house = House(logger)
    await house.buy_new_house()

if __name__ == '__main__':
    asyncio.run(main())
{% endhighlight %}


![house-test](/static/img/egg-inc/house-test.png)


# Step 8
After buying houses, now I need trucks. For simplicity, let me just buy 4. Create `depot.py` under `depot`.

{% highlight python %}
from src.interaction.mouse import Mouse
from src.play.depot.ui_position import (depot_pos,
                                        max_pos1,
                                        max_pos2,
                                        max_pos3,
                                        max_pos4,
                                        exit_pos)
from src.program.debug_class import Debug_Class


class Depot(Debug_Class):
    def __init__(self, logger):
        super().__init__(logger)
        self._mouse = Mouse()

    async def buy_new_trucks(self):
        self.message("Open shipping menu.")
        self._mouse.click_pos(depot_pos, 0.7)
        self._mouse.click_pos(depot_pos, 0.7)
        self._mouse.click_pos(depot_pos, 0.7)

        # max out trucks
        self._mouse.click_pos(max_pos1)
        self._mouse.click_pos(max_pos2, once=True)
        self._mouse.click_pos(max_pos3, once=True)
        self._mouse.click_pos(max_pos4, once=True)

        self.message("Purchased trucks.")

        # exit
        self.message("Close menu.")
        self._mouse.click_pos(exit_pos, 0.7)
{% endhighlight %}


Add the following to `depot/ui_position.py`.
{% highlight python %}
depot_pos = [175, 469]

max_pos1 = [266, 292]
max_pos2 = [247, 354]
max_pos3 = [247, 406]
max_pos4 = [247, 451]

exit_pos = [278, 173]
{% endhighlight %}


Test.
{% highlight python %}
import asyncio
from src.log.logger import Logger

async def main():
    logger = Logger()
    depot = Depot(logger)
    await depot.buy_new_trucks()

if __name__ == '__main__':
    asyncio.run(main())
{% endhighlight %}
![truck-test](/static/img/egg-inc/truck-test.png)


# Step 9
So far things have been not very interesting. That's why in the next step I am going to make the program to be able to upgrade Research. I will need to somehow make it finds the upgrade buttons. 

![research-upgrade-button](/static/img/egg-inc/research-upgrade-button.png)


Fortunately, I have done this before. The high level idea is to first pixelate the screenshot. Crop out the green button from it and save it as a template. After that apply template matching to find the positions of buttons in the pixelated screenshot. In the end project the positions back to the positions in the default screenshot and Voila the program knows where to press.


Let's start coding! Create `research.py` under `research`.
{% highlight python %}
import os
import cv2
import time
import numpy as np
from PIL import Image
from src.interaction.mouse import Mouse
from src.play.spawner.spawner import Spawner
from src.program.debug_class import Debug_Class
from src.util.window_getter import get_screenshot_of_chosen_window, get_window_with_title
from src.play.research.ui_position import (research_pos,
                                           drag_from,
                                           drag_to,
                                           exit_pos)


class Research(Debug_Class):
    def __init__(self, window, logger):
        super().__init__(logger)
        self._mouse = Mouse()
        self._window = window
{% endhighlight %}

Next let me use this screenshot as an example and I will be finding all upgrade buttons in it.
![research-test2](/static/img/egg-inc/research-test2.png)


The first step is to pixelate this screenshot.
{% highlight python %}
def pixelate(pil_image, factor):
    width, height = pil_image.size

    # assuming factor = 3
    # calculate the new dimensions (each 3x3 block becomes 1 pixel)
    new_width = width // factor
    new_height = height // factor

    # create a new image with the new dimensions
    new_image = Image.new("RGB", (new_width, new_height))

    for i in range(new_width):
        for j in range(new_height):
            # initialize RGB accumulators
            r_total, g_total, b_total = 0, 0, 0

            # sum the colors in the 3x3 block
            for x in range(factor):
                for y in range(factor):
                    # get the pixel at the current position
                    pixel = pil_image.getpixel((i * factor + x, j * factor + y))
                    r_total += pixel[0]
                    g_total += pixel[1]
                    b_total += pixel[2]

            # calculate the average color
            r_avg = r_total // (factor * factor)
            g_avg = g_total // (factor * factor)
            b_avg = b_total // (factor * factor)

            # set the average color in the new image
            new_image.putpixel((i, j), (r_avg, g_avg, b_avg))

    return new_image
{% endhighlight %}


Now let me test this. I want the pixel factor to be 5.


![screenshot-pixelated](/static/img/egg-inc/screenshot-pixelated.png)


That worked pretty well, but there is no need to process the entire image. However, that being said, for simplicity. I am not going to show how to optimize this.


Next I will save the green button template. It's very small ➡️   ![button-template](/static/img/egg-inc/button-template.png)


After we have the template, we can use it.
{% highlight python %}
script_dir = os.path.dirname(os.path.abspath(__file__))
self._template = cv2.imread(os.path.join(script_dir, 'button-template.png'))


def _get_research_position(self, screenshot, factor=5, similarity=0.97):
    result = match_position(self._template, pil_to_cv2(pixelate(screenshot, factor)), similarity)
    if result[1]:
        return [int(item) * factor for item in list(result[1][0])]
    return None
{% endhighlight %}


Here is `pil_to_cv2`.
{% highlight python %}
def pil_to_cv2(pil_image):
    pil_image = pil_image.convert('RGB')
    rgb_array = np.array(pil_image)
    bgr_image = cv2.cvtColor(rgb_array, cv2.COLOR_RGB2BGR)
    return bgr_image
{% endhighlight %}


Here is `match_position`.
{% highlight python %}
def match_position(template, screenshot, similarity=0.97):
    # separate the alpha channel if present
    bgr_template = template[:, :, :3] if template.shape[2] == 4 else template

    # perform template matching
    result = cv2.matchTemplate(screenshot, bgr_template, cv2.TM_CCORR_NORMED)

    # get all locations with similarity above the threshold
    match_locations = np.where(result >= similarity)

    # get the size of the template
    template_h, template_w = bgr_template.shape[:2]

    # create a copy of the screenshot for visualization
    screenshot_with_dots = screenshot.copy()

    # calculate and draw the center positions
    centers = []
    for (x, y) in zip(match_locations[1], match_locations[0]):
        center_x = x + template_w // 2
        center_y = y + template_h // 2
        centers.append((center_x, center_y))

        # draw a red dot at the center
        # cv2.circle(screenshot_with_dots, (center_x, center_y), radius=1, color=(0, 0, 255), thickness=0)

    return screenshot_with_dots, centers
{% endhighlight %}


Test for template matching in pixelated image.
{% highlight python %}
from src.log.logger import Logger


if __name__ == '__main__':
    chosen_window = get_window_with_title('iPhone Mirroring')
    logger = Logger()
    research = Research(chosen_window, logger)
    screenshot = Image.open('research-test2.png')
    research.get_research_position(screenshot)
{% endhighlight %}


Output:
{% highlight shell %}
[(np.int64(51), np.int64(45)), (np.int64(51), np.int64(59)), (np.int64(51), np.int64(72)), (np.int64(51), np.int64(86))]
{% endhighlight %}
![research-test3](/static/img/egg-inc/research-test3.png)


