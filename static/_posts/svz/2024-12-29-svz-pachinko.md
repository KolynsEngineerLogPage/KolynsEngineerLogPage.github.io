---
author: Kolyn090
banner: /static/img/svz/svz-pachinko.png
categories: Log
custom_class: custom-page-content
date: 2024-12-29 17:00:00 -0500
layout: post
permalink: /svz-pachinko/
theme: sushi
title: SvZ Pachinko and Slot Machine
---

Category: Log


Platform: Windows


Prerequisite: Basic Python


## What is the Pachinko mini game?
In Samurai vs Zombies, there is a mode called Pachinko where the players can gain extra game currency and items. The game consumes 'balls' and they can be obtained through battles or game rewards. To play the Pachinko machine, drag down the handler to shoot the ball. 


![The handle](/static/img/svz/svz-pachinko-handle.png)


If you aim correctly, the ball would land in one of the traps, or even better: the Slot machine.

- Landing in a trap will give you coins, multiplied by the Multiplier. The Multiplier is equal to the number of balls in Pachinko, with the minimum being 1 and maximum being 5.

- Landing in the Slot machine will spin it and there would be a chance to get 100 coins or items from it. 

**Traps**


![Trap 1](/static/img/svz/trap-1.png)
This trap randomly gives base 5 / 10 coins for each ball landed in.

![Trap 2](/static/img/svz/trap-2.png)
This trap randomly gives base 25 coins for each ball landed in.


<br>
<br>
## Problem Statement
Our goal is to <u>maximumize the number of coins and game items we can get.</u> One observation we can make is that once the ball passes the Slot machine, it can only go to the middle trap and not others, so the best path seems to be:


![The best path](/static/img/svz/svz-pachinko-best-path.png)



However, as mentioned earlier, the second type of trap gives out 25 coins consistently, which is significantly higher than the first type. Therefore, if you value coins more than game items, you should aim for the second type of trap.


<br>
<br>
## Programmatic approach
Now I will be writing a Python program to play the Pachinko game for me. 
# Step 1
Create a new Python project and create a folder hierarchy like so:


![pachinko-1](/static/img/svz/pachinko-1.png)


# Step 2
The first problem we want to solve is to actually reference the emulator window in Python. We will be analyzing screenshots since there is no access to the internal game data. In this tutorial I am assuming you are using BlueStacks emulator and you are playing the normal version game. You can find how to install [here](/svz-installation/).

---

Create a new script `screen_getter.py` under `util`


{% highlight python %}
import platform
if platform.platform().startswith('Win'):
    import pygetwindow as gw
import PIL.ImageGrab
{% endhighlight %}


Open the terminal and cd to the current project directory. Install the required packages.


{% highlight shell %}
pip install pygetwindow
pip install pillow
{% endhighlight %}

🤓 Pygetwindow is Windows specific so you will want to make sure the platform is Windows. We use it to get the window's reference. Pillow is a powerful image library and later we will be using it for taking the screenshots.

---

Next, write a new function called `get_window_with_title()`. It will look for a window with a specific title. Here I am only going to write the most basic form to get the job done.


{% highlight python %}
def get_window_with_title(title: str):
    def get_window_list_win():
        return gw.getAllWindows()

    def get_win_window():
        for window in get_window_list_win():
            if window.title.startswith(title):
                return window
        return None

    if platform.platform().startswith('Win'):
        return get_win_window()
    else:
        return None
{% endhighlight %}



Now let's test this. Open BlueStacks emulator and run the following code:


{% highlight python %}
if __name__ == '__main__':
    chosen_window = get_window_with_title('BlueStacks App Player')
    print(chosen_window)
{% endhighlight %}

If everything is correct, you should see something like:

{% highlight shell %}
<Win32Window left="-165", top="6", width="987", height="476", title="BlueStacks App Player 10">
{% endhighlight %}

🎉 There we have a reference to the window now!

---

After we have the window, we want to take screenshots from it. Thanks to pillow, this step is not hard. 

{% highlight python %}
def get_screenshot_of_chosen_window(window):
    def run_win():
        x = window.left
        y = window.top
        h = window.height
        w = window.width
        return PIL.ImageGrab.grab(bbox=(x, y, w, h))

    if platform.platform().startswith('Win'):
        return run_win()
    else:
        return None
{% endhighlight %}

🤓 ImageGrab.grab crops out the screenshot of the **entire PC Desktop**  with the provided bounding box. Here, our bounding box is exactly equal to the selected window, so we get its screenshot, <u>a PIL Image object</u>.


📍 The window must be active, otherwise the program won't find it. There should not be any other window above it, otherwise the screenshoter will also take the overlayered window.


Now let's test.

{% highlight python %}
if __name__ == '__main__':
    chosen_window = get_window_with_title('BlueStacks App Player')
    chosen_screen = get_screenshot_of_chosen_window(chosen_window)
    chosen_screen.save('screenshot.png')
{% endhighlight %}

![pachinko-2](/static/img/svz/pachinko-2.png)

🤓 `Image.save()` saves the Image to the specified path.

---

As you can see, there are some unnecessary regions in our screenshot. Also, the Ads are quite annoying! So our next step will be solving them.


You can 'hide' the ads by simplying moving BlueStacks emulator to the corner of the Desktop!

![pachinko-3](/static/img/svz/pachinko-3.png)

The next thing is that we only want the region within the marked boundary:

![pachinko-4](/static/img/svz/pachinko-4.png)

This is going to be a little hard but please bear with me. Now essentially we need to determine the bounding box of the marked region. To achieve this, I am going to write a program that can record mouse coordinates on the Desktop.


First, create `program_obj.py` and `program_stopper.py` under `program` directory.

<br>
In `program_stopper.py`

{% highlight python %}
import keyboard
import threading
import os


# Observing key event to check for program termination.
class Program_Stopper:
    def __init__(self):
        self.running = True
        print("Press 'q' to stop the program.")

        # Start a new thread to observe for the 'q' key press
        self.observer_thread = threading.Thread(target=self.observe_stop_key)
        self.observer_thread.start()

    def observe_stop_key(self):
        # Loop until 'q' is pressed
        while self.running:
            if keyboard.is_pressed('q'):
                self.running = False
                print("Stopping the program...")
                os._exit(0)
                break

    def stop(self):
        # Call this method to stop manually if needed
        self.running = False
        if self.observer_thread.is_alive():
            self.observer_thread.join()  # Wait for the observer thread to finish

{% endhighlight %}

🤓 The only thing this class does is to terminate the program when the key 'q' is pressed. You might need to grant system permissions for this to work.

<br>
In `program_obj.py`

{% highlight python %}
from src.program.program_stopper import Program_Stopper


# Contains references to program objects
class Program_Obj:
    def __init__(self):
        self.program_stopper = Program_Stopper()
{% endhighlight %}

🤓 The Program_Obj class instantiates a Program_Stopper and stopper listens to the 'q' key for termination, as mentioned earlier.


We will be using Program_Obj shortly. Now moving onto mouse coordinate.


Create `mouse_coordinate.py` under `util`, write
{% highlight python %}
from pynput import *
from src.program.program_obj import Program_Obj
{% endhighlight %}

Install the package
{% highlight shell %}
pip install pynput
{% endhighlight %}

🤓 We use pynput here to get the mouse information.

<br>
Now add
{% highlight python %}
if __name__ == '__main__':
    def get_coords(x, y):
        print("Now at: {}".format((x, y)))

    Program_Obj()
    with mouse.Listener(on_move=get_coords) as listen:
        listen.join()
{% endhighlight %}

Here, we have instantiated Program_Obj and it's ok that we can just leave it there. We will be able to terminate the program when 'q' is pressed. 

🤓 `mouse.Listener` is a Thread. In this case, it listens to the mouse movement. Basically, it calls assigned `on_move` function when mouse moves. In this case, I want it to print `x` and `y` coordinates. 


🎉 Now we got a program that can determine mouse coordinates. You should try this program before proceeding to the next step. Run the program and you should expect mouse coordinate printed. Remember, press 'q' key to stop.


<br>
<br>
Still remember our task? Determine the bounding box of the window. 


I apologize but you will have to put the ads back, for now.
![pachinko-5](/static/img/svz/pachinko-5.png)
Align the edge of the ads perfectly with the edge. Now comes the important part, run `mouse_coordinate.py` and record the positions of these two points (top-left and bottom-right):
![pachinko-6](/static/img/svz/pachinko-6.png)


I got:
`(164, 32)` and `(950, 482)`


🤓 This means that the first point is 164 pixels away from the left edge and 32 pixels away from the top edge of the Desktop. The second point is 950 pixels away from the left edge and 482 pixels away from the top edge of the Desktop. Awesome!


Now you can just go ahead and modify the main function in `screen_getter.py` to
{% highlight python %}
if __name__ == '__main__':
    chosen_window = get_window_with_title('BlueStacks App Player')
    chosen_screen = get_screenshot_of_chosen_window(chosen_window)
    chosen_screen.save('screenshot.png')
    crop_bound = (164, 32, 950, 482)  # whatever values you got
    game_zone = chosen_screen.crop(crop_bound)
    game_zone.save('game_zone.png')
{% endhighlight %}
Run and you should get an almost perfect game zone screenshot (and you can hide the ads now. It will work with & without ads).
![game_zone](/static/img/svz/game_zone.png)

---

Now we can get the screenshot, but we still need to <u>find a way to maintain the same window size each time we open the app.</u> **I will be showing you the approach that hides the ads; if you do not want to hide them you might have to do some extra works to get it right.**


Create `window_rescaler.py` in `util`, put
{% highlight python %}
from src.util.screen_getter import get_window_with_title

# Rescale the window to fit the requirement
if __name__ == '__main__':
    chosen_window = get_window_with_title('BlueStacks App Player')
    top, left, bottom, right = 0, -164, 482, 819

    # Calculate the width and height based on the bounds
    width = right - left
    height = bottom - top

    if chosen_window:
        chosen_window.activate()

        chosen_window.moveTo(left, top)
        print(f"Left: {chosen_window.left}, Top: {chosen_window.top}")
        chosen_window.resizeTo(width, height)

        print(f"Window resized to top-left ({left}, {top}) with width {width} and height {height}.")
    else:
        print('Window not found, cannot rescale')
{% endhighlight %}

🤓 Here, to get `top`, `left`, `bottom`, `right`, you will have to use mouse coordinate again. 
- top: **0**, assuming you have almost perfectly put the emulator window in the top-left corner of the Desktop.
- left: negative [the x-coordinate of the top-left marked dot]. Mine is 164 so I put **-164** here.
- bottom: [the y-coordinate of the bottom-right marked dot]. Mine is 482 so I put **482** here.
- right: A tricky one. Use mouse coordinate again, but this time <u>hide the ads</u>. Measure the bottom-right marked dot position. Take the y-coordinate of the measured result. I got **819**.


Run the code and you should expect the window moved to the specified location.


📍 Trouble shooting: If the window moved to a wrong location / not moving at all. Try manually dragging it to somewhere else and run the code again until it gets right. I speculate that there are some unknown issues with the pygetwindow's `move` / `moveTo` functions.


⭐ Hint: Check the print result `Left: ..., Top: ...`; if they don't match your set values, that means the window has not moved to the expected location.


<br>
<br>
🎉 Excellent! Now we can get perfect screenshots. Let's move onto the next step.


## Step 3
