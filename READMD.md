## User system

I used devise to implement the user system.

## User online info

* I took advantage of devise's trackable function to track the user login count.
* I added a column to track the total online time.I set the time when user visits the page, calculate and add the interval time to user's online time and update it.

## Stranger online info

I just used js to update the time.

## Online users and strangers count

* I added a column to track if the user is online.
* I have not fount a good way to implement the online strangers count.

## Use can login by username

I had no time to implement this because I think it's a easy and less-important function so I can do this later by using guide of devise.

## The api for online info

I create a route rule and a controller to return the online info with json format.

