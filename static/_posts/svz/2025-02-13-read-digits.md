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

In class `Reader`, add function
{% highlight python %}
def extract(self):
    # region = get_chosen_region(self._window, self._bound)
    region = Image.open('debug/samurai-read-digits-example.png')
    region = region.crop(self._bound)
    processed_image = self._process_image(region)
{% endhighlight %}
🤓 We will be using the example image for now and will be later changed to reading from emulator.

---

Now write the function to process the image. This will be steps 1 - 4. Let's start with step 1: quantize the image. Create a new function in `Reader`.
{% highlight python %}
@staticmethod
def _process_image(img):
    def rescale_and_quantize(image: Image.Image, scaling_factor=2, quantize_factor=3) -> Image.Image:
        new_size = (image.width * scaling_factor, image.height * scaling_factor)
        image = image.resize(new_size, Image.Resampling.BILINEAR)
        return image.quantize(colors=quantize_factor, method=Image.Quantize.FASTOCTREE)

    img = rescale_and_quantize(img, 2, 6)
    if self.debug:
        img.save('debug/quantized.png')
    return img
{% endhighlight %}
🤓 The `rescale_and_quantize()` function rescales and quantizes a given PIL image. I decided to scale up by a factor of 2 because I found out that it increases the chance of successful recognitions. I also set quantize factor to 6. That's also from experience. In the real life scenario, you will often need to try out different values in order for things to work.


Now let's test the code.
{% highlight python %}
if __name__ == '__main__':
    reader = Reader(None, leadership_bound_samurai)  # or 'level_progress_bound_samurai' for bound
    reader.debug = True
    reader.extract()
{% endhighlight %}
Run this code and verify that you have quantized.png


![leadership_quantize_samurai](/static/img/svz/leadership_quantize_samurai.png) if you used bound leadership_bound_samurai.


![leadership_quantize_samurai](/static/img/svz/progress_quantize_samurai.png) if you used bound level_progress_bound_samurai.


You can also test out the zombies side, but remember to change your test image path if you decide to do that.

<br>
🎉 Congratulations on finishing up step 1.


# Step 2
In this step we will enhance the black and white colors. We will enhance it to the extend that the resulting image will only contain white, black, and gray colors. In `_process_image()`, add
{% highlight python %}
def enhance_black_and_white(image: Image.Image, factor=5) -> np.ndarray:
    grayscale = image.convert("L")
    image_array = np.array(grayscale, dtype=np.float32)
    image_array /= 255.0  # normalize
    image_array = (image_array - 0.5) * factor + 0.5  # increase contrast
    image_array = np.clip(image_array, 0, 1)  # keep values in valid range
    image_array = (image_array * 255).astype(np.uint8)  # convert back to 255 scale

    return image_array

img = rescale_and_quantize(img, 2, 6)
if self.debug:
    img.save('debug/quantized.png')
img = enhance_black_and_white(img, 5)
if self.debug:
    img.save('debug/enhance_black_and_white.png')
return img
{% endhighlight %}
🤓 `enhance_black_and_white()` takes a PIL image and returns a cv2 image. Notice that we will be working with cv2 images on this point forward. It first converts the image to grayscale and normalize the image to the range between 0 and 1. After that it increases the contrast by the given factor. In the end it converts the range back to between 0 and 255.


Run the driver code again and verify you have a new debug image.


![leadership_enhance_samurai](/static/img/svz/leadership_enhance_samurai.png) if you used bound leadership_bound_samurai.


![leadership_enhance_samurai](/static/img/svz/progress_enhance_samurai.png) if you used bound level_progress_bound_samurai.

<br>
🎉 Good job completing step 2!


# Step 3
This step is going to be a little tough. By this point we have images that are most white-background-black-text and black-background-white-text, but we only want white-background-black-text images. So the current task is really just to **figure out if an image is black-background-white-text and invert it if yes**. 


To identify whether it has black-background, we can take the colors from <u>the first row and the first column</u> and calculate their mean. If it's below the threshold the background would be black otherwise white.


Here is the code. Add it to `_process_image()`
{% highlight python %}
def get_background_color(image: np.ndarray) -> Tuple[int, int, int]:
    # extract first row and first column
    first_row = image[0, :]  # all pixels in the first row
    first_col = image[:, 0]  # all pixels in the first column

    # combine both sets of pixels
    combined_pixels = np.hstack((first_row, first_col))

    # calculate the average color
    avg_color = np.mean(combined_pixels, axis=0).astype(int)

    # determine if it's closer to white (255, 255, 255) or black (0, 0, 0)
    threshold = np.array([127, 127, 127])
    # set to (255, 255, 255) if closer to white
    # otherwise (0, 0, 0)
    binary_color = (255, 255, 255) if np.all(avg_color > threshold) else (0, 0, 0)

    return binary_color

def convert_to_white_bg(image: np.ndarray) -> np.ndarray:
    bg_color = get_background_color(image)
    if bg_color != (255, 255, 255):
        image = cv2.bitwise_not(image)
    return image

img = rescale_and_quantize(img, 2, 6)
if self.debug:
    img.save('debug/quantized.png')
img = enhance_black_and_white(img, 5)
if self.debug:
    img.save('debug/enhance_black_and_white.png')
img = convert_to_white_bg(img)
if self.debug:
    img.save('debug/convert_to_white_bg.png')
return img
{% endhighlight %}
🤓 `get_background_color()` calculates the mean of the colors in the first row and first column in the image. `convert_to_white_bg()` inverts the image color if it's black background.


Verify you have the debug image.


![leadership_converted_samurai](/static/img/svz/leadership_converted_samurai.png) if you used bound leadership_bound_samurai.


![progress_converted_samurai](/static/img/svz/progress_converted_samurai.png) if you used bound level_progress_bound_samurai.

<br>
🎉 Great! Onto step 4.


# Step 4
This step is quite easy and we have done it before. Convert the image to binary. Add the following to `_process_image()`.
{% highlight python %}
def convert_to_binary(image: np.ndarray, threshold=30) -> np.ndarray:
    _, binary_array = cv2.threshold(image, threshold, 255, cv2.THRESH_BINARY)
    return binary_array

img = rescale_and_quantize(img, 2, 6)
if self.debug:
    img.save('debug/quantized.png')
img = enhance_black_and_white(img, 5)
if self.debug:
    img.save('debug/enhance_black_and_white.png')
img = convert_to_white_bg(img)
if self.debug:
    img.save('debug/convert_to_white_bg.png')
img = convert_to_binary(img, 30)
if self.debug:
    img.save('debug/convert_to_binary.png')
return img
{% endhighlight %}


Again, verify you have the debug image.


![leadership_binary_samurai](/static/img/svz/leadership_binary_samurai.png) if you used bound leadership_bound_samurai.


![progress_binary_samurai](/static/img/svz/progress_binary_samurai.png) if you used bound level_progress_bound_samurai.

<br>
🎉 Things are looking well.


