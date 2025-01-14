---
author: Kolyn090
banner: /static/img/2-softwares/nonogram-solver/talpia.png
categories: Tutorial
custom_class: custom-page-content
date: 2025-01-13 20:00:00 -0500
layout: post
permalink: /software-nonogram-solver-import-image/
title: How to use 'import puzzle from image' feature (experimental) in Nonogram Solver
---

**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: Tutorial


Prerequisite: Basic Python


## Introduction
[Nonogram Solver](https://github.com/Kolyn090/nonogram.git) is a puzzle solver for [Nonogram](https://en.wikipedia.org/wiki/Nonogram) I made a while ago. Its algorithm is based on [fedimser](https://github.com/fedimser)'s [nonolab](https://github.com/fedimser/nonolab).


Nonogram Solver currently supports solving Nonogram puzzles, importing puzzles, and exporting puzzles. **Most importantly, importing puzzles from images.** Today I will be teaching you how to import puzzle from image in Nonogram Solver.


## Table of Contents
- Installation
- How to import from image
- How to import for Picture Cross via MacOS QuickTime Player
- Code intuition


# Step 1
Clone this project to your computer.
{% highlight shell %}
git clone https://github.com/Kolyn090/nonogram.git
{% endhighlight %}


# Step 2
To open the application, go to `src/ui/main.py` and run
{% highlight shell %}
python main.py
{% endhighlight %}


You should see a new window like this.


![default-ui](/static/img/2-softwares/nonogram-solver/default-ui.png)


We have just verified that you can run this app. Let's close this window for now.

---

Now get a screenshot of a Nonogram. It can be something like


![puzzle-nonograms](/static/img/2-softwares/nonogram-solver/puzzle-nonograms.png)


Puzzle from [puzzle-nonograms.com](https://www.puzzle-nonograms.com/?pl=ede55c17a6df3eefbb822c911757bd136785c9eaa1098)


or


![quicktime_screenshot](/static/img/2-softwares/nonogram-solver/quicktime_screenshot.png)


and more... As long as you make sure the contrast between digits and background is high.

---

The only two things this program cares about in these images are just two grids of numbers. I meant that by


![puzzle-nonograms2](/static/img/2-softwares/nonogram-solver/puzzle-nonograms2.png)


![quicktime_screenshot2](/static/img/2-softwares/nonogram-solver/quicktime_screenshot2.png)


<br>
To make the program be able to recognize these two regions, you will have to know and modify the bounding boxes of them. Such as


![quicktime_screenshot3](/static/img/2-softwares/nonogram-solver/quicktime_screenshot3.png)


Use an image editor to look for these points and record them in `src/image_recognition/ui_position.py`.
{% highlight python %}
top_matrix_region = [385, 460, 1370, 760]
bottom_matrix_region = [60, 780, 380, 1770]
{% endhighlight %}

---

Go to `src/image_recognition/main.py`, find these two lines (should be close to the top in `get_two_vector_matrices()`)
{% highlight python %}
screenshot = Screenshot("QuickTime Player").image
# screenshot = cv2.imread('test/screenshot/quicktime_screenshot.png')
{% endhighlight %}

Change to
{% highlight python %}
# screenshot = Screenshot("QuickTime Player").image
screenshot = cv2.imread('test/screenshot/quicktime_screenshot.png')
{% endhighlight %}


Currently the program will not attempt to take screenshot from 'QuickTime Player' but reading a local screenshot. To find the specified image, go to `src/image_recognition` find `/test/screenshot/quicktime_screenshot.png`. You will find that it's the one shown above from Picture Cross. You can add more screenshots under `screenshot` folder. Change the image path so that `cv2` will read your screenshot.


Or it's perfectly fine to use the current setting for testing. Run the application and click the 'Experimental' button. The program will attempt to load the puzzle and it could take some time to finish. After it has finished running. Try to fix the missing digits. The program currently isn't perfect and it tends to create errors, especially for the bottom matrix. 


Using the default setting, after the program solves the puzzle, you would get


![default-setting](/static/img/2-softwares/nonogram-solver/default-setting.png)


# Step 3
