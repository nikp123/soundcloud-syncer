#!/bin/bash
username="$1"
client_id="$2"
DEBUG=0
OVERWRITE=0

function fix_genre() {
	declare -n ret=$1
	
	# lowercase everything and give the first letter in the word an uppercase
	ret=${ret,,}
	ret=$(echo "$ret" | sed 's/[^ _-]*/\u&/g')

	# common fixes per genre because they basically mean the same thing
	# and adjustments so that the ID3 tag system is satisfied
	ret=${ret/110 Bpm/Glitch}
	ret=${ret/110bpm/Glitch}
	ret=${ret/Glitch Hop/Glitch}
	
	ret=${ret/Chill Out/Chillout}
	
	ret=${ret/Dance & EDM/Dance}
	
	ret=${ret/Drum And Bass/Drum & Bass}
	ret=${ret/Drumstep/Drum & Bass} # Technically a subgenre, don't argue
	ret=${ret/Melodic Drumstep/Drum & Bass}
	ret=${ret/Melodic Drum & Bass/Drum & Bass}
	ret=${ret/Drum N Bass/Drum & Bass}
	ret=${ret/Dnb/Drum & Bass}

	ret=${ret/Edm/Electronic}

	# idfk soundcloud machine broke
	ret=${ret/Electro\\ House/Electro House}

	ret=${ret/Indie Dance \/ Nu Disco/Indie Dance}
	ret=${ret/Nu Disco/Indie Dance}

	ret=${ret/Breakbeats/Breakbeat}
	ret=${ret/Break/Breakbeat}
	ret=${ret/Breakbeatbeat/Breakbeat} # cancerous code

	ret=${ret/Electronica/Electronic} # Electronica is not a genre, but rather a term
	
	ret=${ret/Tropical House/House} # double subgenre, wow

	ret=${ret/Electronic House/Electro House}
	ret=${ret/Complextro/Electro House}

	ret=${ret/Electro Pop/Synthpop}
	
	ret=${ret/FutureBass/Future Bass}
	ret=${ret/Midtempo \/ Future Bass/Future Bass}

	ret=${ret/Hard Dance/Hard House} # this is retarded, but whatever

	ret=${ret/Melodic Dubstep/Dubstep}
	
	ret=${ret/Melodic/Instrumental}
	ret=${ret/Piano/Instrumental}
	
	ret=${ret/Post Rock/Post-Rock}

	ret=${ret/Progressive House/House}
	
	ret=${ret/Progressive Trance/Trance}
	ret=${ret/Future Trance/Trance}

	ret=${ret/Space Music/Space}

	ret=${ret/Cinematic/Soundtrack} # am still not sure

	ret=${ret/Future Trap/Trap} # why do artists do weird shit like this

	ret=${ret/hiphop/Hip-Hop}
	
	
	# check if that genre is valid against the list
	# genre list provided by https://en.wikipedia.org/wiki/ID3 
	FOUND=0
	GENRES_LIST='"Blues" "Classic Rock" "Country" "Dance" "Disco" "Funk" "Grunge" "Hip-Hop" "Jazz" "Metal" "New Age" "Oldies" "Other" "Pop" "R&B" "Rap" "Reggae" "Rock" "Techno" "Industrial" "Alternative" "Ska" "Death Metal" "Pranks" "Soundtrack" "Euro-Techno" "Ambient" "Trip-Hop" "Vocal" "Jazz+Funk" "Fusion" "Trance" "Classical" "Instrumental" "Acid"	"House" "Game" "Sound Clip" "Gospel" "Noise" "Alternative Rock" "Bass" "Soul" "Punk" "Space" "Meditative" "Instrumental Pop"	"Instrumental Rock" "Ethnic" "Gothic" "Darkwave" "Techno-Industrial" "Electronic" "Pop-Folk" "Eurodance" "Dream" "Southern Rock"	"Comedy" "Cult" "Gangsta" "Top 40" "Christian Rap" "Pop/Funk" "Jungle" "Native US" "Cabaret" "New Wave" "Psychedelic" "Rave"	"Showtunes" "Trailer" "Lo-Fi" "Tribal" "Acid Punk" "Acid Jazz" "Polka" "Retro" "Musical" "Rock & Roll" "Hard Rock" "Folk" "Folk-Rock" "National Folk" "Swing" "Fast Fusion" "Bebob" "Latin" "Revival" "Celtic" "Bluegrass" "Avantgarde" "Gothic Rock"	"Progressive Rock" "Psychedelic Rock" "Symphonic Rock" "Slow Rock" "Big Band" "Chorus" "Easy Listening" "Acoustic" "Humour"	"Speech" "Chanson" "Opera" "Chamber Music" "Sonata" "Symphony" "Booty Bass" "Primus" "Porn Groove" "Satire" "Slow Jam" "Club" "Tango" "Samba" "Folklore" "Ballad" "Power Ballad" "Rhytmic Soul" "Freestyle" "Duet" "Punk Rock" "Drum Solo" "Acapella"	"Euro-House" "Dance Hall" "Goa" "Drum & Bass" "Club-House" "Hardcore" "Terror" "Indie" "BritPop" "Negerpunk" "Polsk Punk"	"Beat" "Christian Gangsta" "Heavy Metal" "Black Metal" "Crossover" "Contemporary C" "Christian Rock" "Merengue" "Salsa" "Thrash Metal" "Anime" "JPop" "Synthpop" "Abstract" "Art Rock" "Baroque" "Bhangra" "Big beat" "Breakbeat" "Chillout" "Downtempo" "Dub" "EBM" "Eclectic" "Electro" "Electroclash" "Emo" "Experimental" "Garage" "Global" "IDM" "Illbient" "Industro-Goth" "Jam Band" "Krautrock" "Leftfield" "Lounge" "Math Rock" "New Romantic" "Nu-Breakz" "Post-Punk" "Post-Rock" "Psytrance" "Shoegaze" "Space Rock" "Trop Rock" "World Music" "Neoclassical" "Audiobook" "Audio theatre" "Neue Deutsche Welle" "Podcast" "Indie-Rock" "G-Funk" "Dubstep" "Garage Rock" "Psybient"'
	# added genres (AVOID SUBGENRES AS THERE ARE A LOT OF THEM)
	# https://en.wikipedia.org/wiki/Alternative_dance (aka. Indie Dance)
	# https://en.wikipedia.org/wiki/Electro_house (aka. Electro House, Complextro)
	# https://en.wikipedia.org/wiki/Future_bass (aka. Future Bass)
	# https://en.wikipedia.org/wiki/Future_house (aka. Future House)
	# https://en.wikipedia.org/wiki/Glitch_(music) (aka. Glitch)
	# https://en.wikipedia.org/wiki/Happy_hardcore (aka. Happy Hardcore)
	# https://en.wikipedia.org/wiki/UK_hard_house (aka. Hard House)
	# https://en.wikipedia.org/wiki/Synthwave (aka. Synthwave)
	# https://en.wikipedia.org/wiki/Trap_music_(EDM) and https://en.wikipedia.org/wiki/Trap_music (aka. Trap)
	# https://en.wikipedia.org/wiki/UK_hardcore (aka. UK Hardcore)
	# https://en.wikipedia.org/wiki/Pop_punk (aka. Pop Punk)
	GENRES_LIST="$GENRES_LIST \"Indie Dance\" \"Electro House\" \"Future Bass\" \"Future House\" \"Glitch\" \"Happy Hardcore\" \"Hard House\" \"Synthwave\" \"Trap\" \"UK Hardcore\" \"Pop Punk\""
	
	eval 'for word in '$GENRES_LIST'; do 
		if [ "$word" == "$ret" ]; then
			FOUND=1;
		fi;
	done'
	if (( FOUND == 0 )); then
		printf "\n$ret is not a valid genre." 
		ret="INVALID_GENRE"
	fi	
}

function fix_author_and_title() {
	# fix author names and titles
	if [[ ${stream_title[$j]} == "Monstercat "* ]]; then
		author[j]="Monstercat"
		stream_title[j]=${stream_title[j]#*"Monstercat "}
	else
		case ${stream_title[$j]} in 
			(*" - "*)
				author[j]=${stream_title[j]%%" - "*}
				stream_title[j]=${stream_title[j]#*" - "}
				;;
		esac
	fi
	author[j]=$(echo -e "${author[$j]}"|awk -F'/' '{print $1}'|sed -e 's/\*//g')
	stream_title[j]=$(echo -e "${stream_title[$j]}"|awk -F'/' '{print $1}'|tr -d \'|sed -e 's/[ \t]*$//;s/ \[Free Download\]//g;s/ \[FREE DOWNLOAD\]//g;s/ \[[^]]*Release\]//g;s/ \[[^]]*Exclusive\] //g;s/ \*FREE DOWNLOAD\*//g')

	#author[j]=${author[$j],,}
	#author[j]=$(echo "${author[$j]}"|sed 's/[^ (._-]*/\u&/g;s/*//g')
}

# album:
# url=$(cat example.json | jq -r ".collection[].purchase_url" | grep album)
# echo ${url#*"album/"}|cut -d'/' -f1|sed 's/-/ /g;s/ single//g;s/[^ ]*/\u&/g'

echo -n "Getting user info: "
userinfo=$(curl "https://api.soundcloud.com/users/$username?client_id=$client_id" 2> /dev/null) 
echo "done"

# Getting info about likes
echo -n "Downloading song info: "
number_of_likes=$(echo $userinfo|jq -r '.public_favorites_count')
address="https://api.soundcloud.com/users/$username/favorites?client_id=$client_id&limit=200&linked_partitioning=1"
j=0
lastcount=0
echo "done"

# count number of songs in the playlist
echo -n "Calculating the \"ACTUAL\" number of songs: "
m=0
for (( i=0; i<number_of_likes; i+=200 )); do
	list=$(curl "$address" 2> /dev/null)
	n=$(echo $list|jq '.collection | length')
	(( m+=n ))
	address=$(echo $list|jq -r '.next_href')
done
echo "done"
(( m-- ))

# insert them into the database
address="https://api.soundcloud.com/users/$username/favorites?client_id=$client_id&limit=200&linked_partitioning=1"
for (( i=0; i<number_of_likes; i+=200 )); do
	IFS=$' '
	# 200 is the undocumented limit of how many songs can be pulled from a single query
	list=$(curl "$address" 2> /dev/null)
	listcount=$(echo $list|jq '.collection | length')
	(( maxcount+=listcount ))
	address=$(echo $list|jq -r '.next_href')
	
	echo -n "Getting info about $listcount/$m tracks: "
	stream_title="$(echo $list|jq -r '.collection[].title'|tr \| '-'|sed -e 's/;/ - /g'|tr -d '?'|sed -e 's/:/ -/g')"
	IFS=$'\n' stream_title=($stream_title)
	IFS=$' '
	author="$(echo $list|jq -r '.collection[].user.username')"
	IFS=$'\n' author=($author)
	IFS=$' '
	echo "done"

	(( lastcount+=j ))
	for (( j=0; j<listcount; j++ )); do
	 
		fix_author_and_title
		
		# song filename
		filename="${stream_title[$j]}.mp3"

		if [ "$DEBUG" -eq 0 ] && [ "$OVERWRITE" -eq 0 ]; then
			# if the file exists, just skip the song	
			if [[ -f "${author[$j]}/$filename" ]]; then
				continue;
			fi
		fi

		echo -n "Downloading and processing ${author[$j]} - ${stream_title[$j]}"

		# getting all the necessary info
		thumbnail_url[j]=$(echo $list|jq -r ".collection[$j].artwork_url")
		# check if the thumbnail exists
		if [ ${thumbnail_url[$j]} == "null" ]; then
			thumbnail_url[j]=$(echo $list|jq -r ".collection[$j].user.avatar_url")
		fi
		echo -n "."
		downloadable[j]=$(echo $list|jq -r ".collection[$j].downloadable")
		echo -n "."
		description[j]=$(echo $list|jq -r ".collection[$j].description")
		echo -n "."
		stream_url[j]=$(echo $list|jq -r ".collection[$j].stream_url")
		echo -n "."

		# check if the song is downloadable
		if [[ "${downloadable[$j]}" == false ]]; then
			download_url="$(curl "${stream_url[$j]}?client_id=$client_id" 2> /dev/null | jq -r '.location')"
		else
			download_url="$(echo $list|jq -r ".collection[$j].download_url")"
			download_url="$download_url?client_id=$client_id"
			fileformat="$(curl -I -L "$download_url" 2> /dev/null)"
			fileformat="echo $fileformat | grep Content-Type:\ audio\/ | awk -F'/' '{print $2;}'"
			# check if its mp3, because otherwise the script breaks
			if [ "$fileformat" != "mpeg" ]; then
				download_url="$(curl "${stream_url[$j]}?client_id=$client_id" 2> /dev/null | jq -r '.location')"
			fi
		fi
		echo -n "."
		
		# Get genre information from SoundCloud
		genre="$(echo $list|jq -r ".collection[$j].genre")"
		fix_genre genre
		# if that fails, we can try to find it in the tags
		if [ "$genre" == "INVALID_GENRE" ]; then
			tags="$(echo $list|jq '.collection['"$j"'].tag_list'|sed -e 's/\\\"/~/g;s/\"//g;s/~/\"/g;s/`//g')"
			# Fixes escape sequences
			tags="$(echo $tags|sed -e 's/\&/\\\&/g')"
			eval 'for tag in '$tags'; do 
				fix_genre tag
				if [ "$tag" != "INVALID_GENRE" ]; then
					break
				fi
			done'
			genre=$tag
			if [ "$genre" == "INVALID_GENRE" ]; then
				genre="Other" # valid ID3 to use when not sure what it is
			fi
		fi
		echo -n "."

		if [ "$DEBUG" -eq 0 ]; then	
			# Download the actual song
			curl -L -o "$filename" "$download_url" &> /dev/null
			echo -n "."
	
			# fix thumbnails so they are actually acceptable
			thumbnail_url[j]=$(echo -e "${thumbnail_url[$j]}"|sed "s/large/t500x500/g")
			
			# download the artwork
			curl -o artwork.jpg ${thumbnail_url[$j]} &> /dev/null
			if [ ! -f artwork.jpg ]; then
				thumbnail_url[j]=$(echo -e "${thumbnail_url[$j]}"|sed "s/t500x500/original/g")
				curl -o artwork.jpg ${thumbnail_url[$j]} &> /dev/null
			fi
			echo -n "."
			
			#echo "Adding $j $stream_pos ${stream_url[$j]} ${stream_title[$j]} ${durstion[$j]} ${author[$j]} ${thumbnail_url[$j]}"
			# Set mp3 ID3 tag information properly
			eyeD3 -a "${author[$j]}" -t "${stream_title[$j]}" -c "${description[$j]}" --add-image "artwork.jpg:FRONT_COVER" -G "$genre" "$filename" &> /dev/null
			echo -n "."
			
			# Create the directory if it doesn't exist
			if [ ! -d "${author[$j]}" ]; then
				mkdir -p "${author[$j]}"
			fi
			# Move the file to the folder to keep it organised
			cp -f "$filename" "${author[$j]}"
			echo -n "."

			# keep clean
			rm "$filename" &> /dev/null
			rm artwork.jpg &> /dev/null
		fi
		echo "done"
	done
done

