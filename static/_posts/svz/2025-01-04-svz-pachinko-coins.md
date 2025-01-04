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


In a grayscale image, each pixel can be represented as an integer ranged from [0, 255]. With **0 being completely black and 255 being completely white.** Everything in between is gray. <u>Therefore, a grayscale image is equivalent to a matrix of integers.</u> When binarize, typically, you will paint a pixel value under certain threshold black. Here, I chose 128 because `255 // 2 + 1 = 128`. 

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

I assume you came with the knowledge of my [previous post](/svz-pachinko/), so I will continue to use the same project hierarchy. 