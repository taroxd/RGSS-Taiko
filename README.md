Taiko no datsujin (RGSS version) 
------

## Download ##
 
Download available at <https://github.com/taroxd/RGSS-Taiko/releases>.

## How To Play ##
Put your tja and ogg file in the "Song" Folder.  
About tja file, see [taikojiro](http://www.nicovideo.jp/watch/sm5463901) for details.  
All the tja function is not supported currently.

Press UP and DOWN arrow keys to select a song. Press LEFT and RIGHT arrow keys to select a course.

|  Function  |  Keys                       |
| ---------- | --------------------------- |
| Confirm    |  Z / Enter / Space          |
| Select     |  Arrow keys / keypad        |
| Cancel     |  X / Esc                    |
| Don!       |  F / J                      |
| Ka!        |  D / K                      |

## Description ##

This is an implementation of Taiko with the help of RPG Maker VX Ace.  
No database, no map, no event.  
The script in the Data/Scripts.rvdata2 is as follows.

```ruby
$LOAD_PATH.push('./lib')
require 'main'
```