Taiko no datsujin (RGSS version) 
------

## Download ##
 
Download available at <https://github.com/taroxd/RGSS-Taiko/releases>.

## How To Play ##
Put your tja and ogg files in the "Song" Folder.  
About tja files, see [taikojiro](http://www.nicovideo.jp/watch/sm5463901) for more details.  
All the tja functions are not supported currently.

Note that:
* Tja files must be UTF-8 encoded.
* The project must be placed in a path that contains no non-ASCII character.

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
The script in the `Data/Scripts.rvdata2` is as follows.

```ruby
$LOAD_PATH.push('./lib')
require 'main'
```

For debugging, uncomment the line `require 'debug'` in `main.rb`.
This will set `$TEST` to true and allocate a console for input and output, just as the RPG Maker VX Ace does.

## Contribute ##

Just send me a pull request.
