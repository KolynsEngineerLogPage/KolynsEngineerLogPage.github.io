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


# Step 1
Since this tutorial is going to be very long and potentially become hard to follow, this time I want to try something different. 


![samurai-read-digits-example](/static/img/svz/samurai-read-digits-example.png)


![zombie-read-digits-example](/static/img/svz/zombie-read-digits-example.png)


Here are the two screenshots I used while I was developing the algorithm. This time I want you to first work with them before moving onto the real game. This ensures that we have the same environment and you will be adapting to your own environment much easier once your understand how it works.

---

Put the two screenshots in your project. Make sure your project have the following structure.


{% highlight cmd %}
ai
|___ player_hp
|    |___ ...
|___ read_digit
|    |___ debug
|    |    |___ samurai-read-digits-example.png
|    |    |___ zombie-read-digits-example.png
|    |___ digits
|    |___ digit_recognizer.py
|    |___ reader.py
|___ config.toml
|___ ui_position.py
{% endhighlight %}

We will be adding more files for debugging purposes via code.

---

In `reader.py`, put
{% highlight python %}
import os
import re
import cv2
import time
import glob
import numpy as np
import pytesseract
from PIL import Image
from typing import Tuple
from src.util.screen_getter import get_chosen_region, get_window_with_title
from src.ai.read_digit.digit_recognizer import Digit_Recognizer
from src.ai.ui_position import leadership_bound_samurai, level_progress_bound_samurai
from src.ai.ui_position import leadership_bound_zombie, level_progress_bound_zombie

script_dir = os.path.dirname(os.path.abspath(__file__))
pytesseract.pytesseract.tesseract_cmd = 'C:\Program Files\Tesseract-OCR\\tesseract.exe'

class Reader:
    def __init__(self, window, bound):
        self._window = window
        self._bound = bound
        self._digit_recognizer = Digit_Recognizer(os.path.join(script_dir, 'digits'))
        self.debug = False
{% endhighlight %}


In `ui_position.py`, add
{% highlight python %}
leadership_bound_samurai = [56, 357, 88, 373]
level_progress_bound_samurai = [183, 51, 225, 69]
leadership_bound_zombie = [62, 357, 94, 373]
level_progress_bound_zombie = [188, 55, 230, 73]
{% endhighlight %}


In `digit_recognizer.py`, put
{% highlight python %}
import os
import cv2
import glob
import numpy as np

class Digit_Recognizer:
    def __init__(self, digits_folder):
        def load_binary(path):
            img = cv2.imread(path, cv2.IMREAD_GRAYSCALE)
            _, binary_img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)
            return binary_img

        self.digit_template = {}

        # search for PNG files under digits folder
        png_files = glob.glob(os.path.join(digits_folder, "*.png"))

        # extract filenames without extension
        filenames = [os.path.splitext(os.path.basename(file))[0] for file in png_files]

        for filename in filenames:
            self.digit_template[filename] = load_binary(f'{digits_folder}/{filename}.png')

    def recognize(self, digit_image):
        def mse(array1, array2):
            r = np.mean((array1 - array2) ** 2)
            return r if r != 0 else 0.001

        similarities = []
        for key, value in self.digit_template.items():
            similarities.append(1 / mse(digit_image, value))

        result = 0
        highest = 0
        for i in range(len(similarities)):
            if similarities[i] > highest:
                highest = similarities[i]
                result = i

        return list(self.digit_template.keys())[result].split('_')[0]
{% endhighlight %}
📍 `Digit_Recognizer` is mostly the same as before, except that I changed the way to load templates. Now you only have to name the template image files correctly (same naming conversion as before) in order to use this class.


In `config.toml`, put
{% highlight toml %}
[digit_reader]
side = "samurai"  # samurai / zombie
{% endhighlight %}
📍 We won't be using this file today.

---

