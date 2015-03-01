Taiko no datsujin (RGSS version) 
------

## Download ##
 
Download available at <https://github.com/taroxd/RGSS-Taiko/releases>.

## How To Play ##
Put your tja and ogg file in the "Song" Folder.  
About tja file, see [taikojiro](http://www.nicovideo.jp/watch/sm5463901).  
Only a small part of the tja function is supported.  
**For example, for every tja file, only the first course will be read.**

|  Function  |  Keys                       |
| ---------- | --------------------------- |
| Confirm    |  Z / Enter / Space          |
| Select     |  Arrow keys / 4, 8 (keypad) |
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