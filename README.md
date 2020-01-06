# soundcloud-syncer
Downloads tracks from SoundCloud

## What does it do, exactly?
In the folder you run it, it downloads songs from the specified users likes 
organized by the song author/uploader.

Besides that, it also sets the appropriate ID3 tags from the information scraped
from the SoundCloud page.

## Pre-requisites
 * bash
 * jq
 * curl
 * eye3D (a Python package)
 * binutils (comes with any UNIX-like system really)

## How to use?
```
./soundcloud_syncer.sh username-here client-id-here
```

### What is a client id?
This script uses the SoundCloud APIs for everything, and API being what application developers
use to interact and extract information from SoundCloud.

You need to get one before you can use this program, it shouldn't be TOO hard to obtain.

Here's some reference on how to do it: https://github.com/Sliim/soundcloud-syncer/issues/4#issuecomment-267834538

## Did you copy the other soundcloud-syncer?
Depends on what you consider copying:
 * If by copying you mean a program that achieves (mostly) the same task - yes
 * If by copying you consider the actual work done - hell no, this script was written from scratch 

And yes, I stole the name because I'm unoriginal :(

## Responsibility
Completely you.

## License and legal
 * For my code: LICENSE file in this repository
 * For others code: The respective programs that my script uses
 * For SoundCloud: Look up the SoundCloud EULA

