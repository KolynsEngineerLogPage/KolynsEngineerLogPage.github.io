---
author: Kolyn090
banner: /static/img/svz/svz-pachinko.png
categories: Tutorial
custom_class: custom-page-content
date: 2025-01-04 11:00:00 -0500
layout: post
permalink: /svz-pachinko-coins/
theme: sushi
title: Getting coins amount with Custom Template
---


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: Tutorial


Platform: Windows


Prerequisite: Basic Python, read [this article](/svz-pachinko/)


## Recap
Last time we attempted the problem of reading coins amount using `pytesseract`. It works but it takes approximately 0.8 seconds to complete for one read, which is slow. That is why today I will introduce to you another way that is way faster (and more accurate) - Template Matching. 


## Template Matching
To perform template matching, you will need about the most (if not all) critical examples. Notice that here we know our digits always have the same typeface and the same font. In our case, assuming your emulator window size is always the same, they are:


![0](/static/img/svz/0.png)
![1](/static/img/svz/1.png)
![2](/static/img/svz/2.png)
![3](/static/img/svz/3.png)
![4](/static/img/svz/4.png)
![5](/static/img/svz/5.png)
![6](/static/img/svz/6.png)
![7](/static/img/svz/7.png)
![8](/static/img/svz/8.png)
![9](/static/img/svz/9.png)


Notice that this is not an exhaustive list. That is because in the game's font, some digits will sometimes 'stick' to other digits. E.g.


![07](/static/img/svz/07.png)
![77](/static/img/svz/77.png)


Sometimes a digit can be read in different forms depending on their current positions. E.g.


![8_2](/static/img/svz/8_2.png)
![9_2](/static/img/svz/9_2.png)


It's hard to see the difference but if you zoom in you will see it.


<br>
That's still far from exhaustive. You might even see 3 or more digits stick together. I hope by now you can realize that sometimes it's very hard to collect all templates. That's why we will have to handle them respectively. 

---

You can use a pixel art editor to get those examples, but I will show you how to do this with Python. Before that, you will have to understand how to get the digits separated. 


Consider this example
![pachinko-8-enlarge](/static/img/svz/pachinko-8-enlarge.png)

Its binarization is
![pachinko-8-enlarge-bw](/static/img/svz/pachinko-8-enlarge-bw.png)


🤓 Binarization simply means to convert an image to strictly black and white (there is no gray). 


In a grayscale image, each pixel can be represented as an integer ranged from [0, 255]. With **0 being completely black and 255 being completely white.** Everything in between is gray. <u>Therefore, a grayscale image is equivalent to a matrix of integers.</u> When binarize, typically, you will paint a pixel value under certain threshold black. Here, I chose 127 because `255 // 2 = 127`. 

<br>
Now we make a wish - somehow we can crop out the digits this way.


![pachinko-8-enlarge-border](/static/img/svz/pachinko-8-enlarge-border.png)


Now we try to make our wish come true. Let's not think about the image as a string of integers for a moment, but a bunch of black blobs. Each black pixel should find a blob it belongs to. One single black pixel can form its own blob, and many black pixels near each other can form a larger blob. 


In this image we have 4 blobs.

![pachinko-8-enlarge-color](/static/img/svz/pachinko-8-enlarge-color.png)


Now imagine applying [Depth First Search](https://en.wikipedia.org/wiki/Depth-first_search) on one of the black pixels to search for blobs. Say, a random pixel in the first blob. You will get


![pachinko-8-enlarge-1](/static/img/svz/pachinko-8-enlarge-1.png)


Now we mark the pixel in the first blob as 'visited' and pick from other pixels in blobs. For example, the second blob.


![pachinko-8-enlarge-14](/static/img/svz/pachinko-8-enlarge-14.png)


Mark the second blob as 'visited', and continue


![pachinko-8-enlarge-14975](/static/img/svz/pachinko-8-enlarge-14975.png)

![pachinko-8-enlarge-149756](/static/img/svz/pachinko-8-enlarge-149756.png)

![pachinko-8-enlarge-149756_0](/static/img/svz/pachinko-8-enlarge-149756_0.png)


In the end, DFS has read:

![pachinko-8-enlarge-1_b](/static/img/svz/pachinko-8-enlarge-1_b.png)

![pachinko-8-enlarge-4_b](/static/img/svz/pachinko-8-enlarge-4_b.png)

![pachinko-8-enlarge-975_b](/static/img/svz/pachinko-8-enlarge-975_b.png)

![pachinko-8-enlarge-6_b](/static/img/svz/pachinko-8-enlarge-6_b.png)


We know that our images consist only black or white pixels. Now we discard all the unnecessary white pixels. 

![pachinko-8-enlarge-1_alpha](/static/img/svz/pachinko-8-enlarge-1_alpha.png)

![pachinko-8-enlarge-4_alpha](/static/img/svz/pachinko-8-enlarge-4_alpha.png)

![pachinko-8-enlarge-975_alpha](/static/img/svz/pachinko-8-enlarge-975_alpha.png)

![pachinko-8-enlarge-6_alpha](/static/img/svz/pachinko-8-enlarge-6_alpha.png)

🎉 There, dear readers. I represent you the 4 blobs.

---

It's great we have the blobs. However, in template matching, we prefer the reference and the compared to have the same size. We can easily achieve this with `cv2` library, but <u>the core idea is to create a background and put the blob in the center.</u> For example


![pachinko-8-enlarge-bg-example](/static/img/svz/pachinko-8-enlarge-bg-example.png)


📍 I painted the border green just to distinguish it from the website background.


Here, we can use this image as one of the **templates** for recognizing digit 6. Next time we see another 6, we can compare it with the template.


![pachinko-8-enlarge-6-alter](/static/img/svz/pachinko-8-enlarge-6-alter.png) compared to ![pachinko-8-enlarge-bg-example](/static/img/svz/pachinko-8-enlarge-bg-example.png) gets score 76.19047619047619

![pachinko-8-enlarge-4-bg-example](/static/img/svz/pachinko-8-enlarge-4-bg-example.png) compared to ![pachinko-8-enlarge-bg-example](/static/img/svz/pachinko-8-enlarge-bg-example.png) gets score 11.129660545353367

I will discuss how to get the scores later.


<br>
<br>
Great. These should be all about template matching. Remember, it has more applications than just recognizing digits. You will see in other posts how I use it in other games such as Egg Inc. and Plants vs Zombies for other things.


## Now, we program
# Step 1

I assume you came with the knowledge of my [previous post](/svz-pachinko/), so I will continue to use the same project hierarchy. First, create a new folder `digit_recognizer` under `pachinko`. Inside `digit_recognizer`, create a new folder `digits` and a new script `digit_recognizer.py`. In `digit_recognizer.py`, put

{% highlight python %}
import os
import cv2
import numpy as np

script_dir = os.path.dirname(os.path.abspath(__file__))
{% endhighlight %}
🤓 `script_dir` is the absolute path to this script file. Later we will be concatenating this with the template images' paths in order to find the templates across the entire project.

<br>
Next we create the class.
{% highlight python %}
class Digit_Recognizer:
    def __init__(self):
        def load_binary(path):
            img = cv2.imread(path, cv2.IMREAD_GRAYSCALE)
            _, binary_img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)
            return binary_img

        self.digit_template = {
            '0': load_binary(os.path.join(script_dir, 'digits/0.png')),
            '1': load_binary(os.path.join(script_dir, 'digits/1.png')),
            '2': load_binary(os.path.join(script_dir, 'digits/2.png')),
            '3': load_binary(os.path.join(script_dir, 'digits/3.png')),
            '4': load_binary(os.path.join(script_dir, 'digits/4.png')),
            '5': load_binary(os.path.join(script_dir, 'digits/5.png')),
            '6': load_binary(os.path.join(script_dir, 'digits/6.png')),
            '7': load_binary(os.path.join(script_dir, 'digits/7.png')),
            '8': load_binary(os.path.join(script_dir, 'digits/8.png')),
            '9': load_binary(os.path.join(script_dir, 'digits/9.png'))
        }
{% endhighlight %}
🤓 `load_binary` loads the image in given path and convert to binary. It first converts the image to grayscale, then apply `threshold` on it. Every pixel value greater than the `threshold` (127) will be set to the `maxval` (255) and everything less will be set to 0. `self._digit_template` is a dictionary that stores all digits along with its template. This dictionary is not final, later we will be adding more things to it.

<br>
`Digit_Recognizer` must be able to `recognize`, let's create this function.
{% highlight python %}
def recognize(self, compared):
    def mse(array1, array2):
        r = np.mean((array1 - array2) ** 2)
        return r if r != 0 else 0.001

    similarities = []
    for key, value in self._digit_template.items():
        similarities.append(1 / mse(compared, value))

    result = 0
    highest = 0
    for i in range(len(similarities)):
        if similarities[i] > highest:
            highest = similarities[i]
            result = i

    return list(self._digit_template.keys())[result]
{% endhighlight %}
🤓 Inside `recognize`, there is an inner function `mse`. This stands for **Mean Square Error**. It essentially compares to numpy arrays and returns a value. <u>Smaller the value, more similar the two images are.</u> It will return 0 if the two images are identical. 


We will apply `mse` to the `compared` with all templates from 0 - 9. For similarity, we choose `1 / mse`, in this way it's more clear. That's why I want to return a small value like `0.001` instead of `0` to prevent zero divisions. We get a list of similarities and the next thing is to find the biggest one among them and its associated key will be the digit we are looking for.

<br>
We can test this. Drag and download the following images to `digits`.
![0](/static/img/svz/0.png)![1](/static/img/svz/1.png)![2](/static/img/svz/2.png)![3](/static/img/svz/3.png)![4](/static/img/svz/4.png)![5](/static/img/svz/5.png)![6](/static/img/svz/6.png)![7](/static/img/svz/7.png)![8](/static/img/svz/8.png)![9](/static/img/svz/9.png)

{% highlight python %}
if __name__ == '__main__':
    def load_binary(path):
        img = cv2.imread(path, cv2.IMREAD_GRAYSCALE)
        _, binary_img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)
        return binary_img
    
    digit_recognizer = Digit_Recognizer()
    comparing = load_binary('digits/0.png')
    print(digit_recognizer.recognize(comparing))

{% endhighlight %}


outputs


{% highlight shell %}
0
{% endhighlight %}

Print the `similarities` list, we get
{% highlight shell %}
[1000.0, np.float64(10.867924528301886), np.float64(16.0), np.float64(16.45714285714286), np.float64(9.931034482758621), np.float64(13.09090909090909), np.float64(12.0), np.float64(14.048780487804878), np.float64(11.294117647058822), np.float64(14.399999999999999)]
{% endhighlight %}


The first key, 0, is indeed the most similar to itself.


# Step 2
