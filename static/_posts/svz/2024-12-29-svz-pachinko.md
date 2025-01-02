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
