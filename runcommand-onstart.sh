#!/usr/bin/env bash

# get the system name
system="$1"

#get the specific emu name
emu="$2"

# get the rom name
rom="$3"

echo $system >&2
echo $emu >&2
echo $rom >&2

# apply Atari 8-bit specific patches to retroarch-core-options.cfg and to atari800.cfg
# [202202] Updated [atari800.cfg] to [lr-atari800.cfg]
#
# [202202] Updated to include all x3 [retroarch-core-options.cfg] Locations:
# /opt/retropie/configs/all/retroarch-core-options.cfg
# /opt/retropie/configs/atari800/retroarch-core-options.cfg
# /opt/retropie/configs/atari5200/retroarch-core-options.cfg
#
# This script presumes a romset with filenames in  formats like:
## Dreadnought Megastars (1990)(Byte Back)(PAL)(GB)[k-file].atr  <--- we search for "PAL"
## Beer Shot (1994)(Bednar, Kamil)(PD)[BASIC].atr <---- we search for "BASIC"
## Head over Heels (19xx)(Hit Squad)(GB)[h Homesoft][k-file] <--- this triggers no special behavior

if [ $system == "atari800" ]; then
  #echo "Atari 800 requested." >&2

  # if the ROM filename contains BASIC (typically as [BASIC]) then enable BASIC.
  # note that this will not work for .BAS files; those need to be loaded from
  # the BASIC prompt itself

  if [[ $rom == *BASIC* ]]; then
    echo "BASIC program detected." >&2
    sed -i 's/atari800\_internalbasic = .*/atari800\_internalbasic = \"enabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_internalbasic = .*/atari800\_internalbasic = \"enabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_internalbasic = .*/atari800\_internalbasic = \"enabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/DISABLE\_BASIC=.*/DISABLE\_BASIC=0/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  else
    # otherwise, turn it off
    sed -i 's/atari800\_internalbasic = .*/atari800\_internalbasic = \"disabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_internalbasic = .*/atari800\_internalbasic = \"disabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_internalbasic = .*/atari800\_internalbasic = \"disabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/DISABLE\_BASIC=.*/DISABLE\_BASIC=1/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  fi

  # if the ROM filename contains [OSa] then set BASIC version to Rev. A and
  # machine OS version to 400/800 OS A.
  # Revision A BASIC has an md5 of a4dc52536d526ecc51ea857b9fa2b90f and is not
  # typically called ATARIBAS.ROM.

  if [[ $rom == *OSa* ]]; then
    echo "Game requires OSa." >&2
    sed -i 's/atari800\_system = .*/atari800\_system = \"400\/800 \(OS B\)\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_system = .*/atari800\_system = \"400\/800 \(OS B\)\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_system = .*/atari800\_system = \"400\/800 \(OS B\)\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/BASIC\_VERSION=.*/BASIC\_VERSION=A/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/OS\_400\/800\_VERSION.*/OS\_400\/800\_VERSION=A-PAL/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  elif [[ $rom == *OSb* ]]; then

    # if it's OSb, also do 400/800, but set it to the custom ROM, which is the
    # recommended ATARIOSB.ROM on the wiki

    echo "Game requires OSb." >&2
    sed -i 's/atari800\_system = .*/atari800\_system = \"400\/800 \(OS B\)\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_system = .*/atari800\_system = \"400\/800 \(OS B\)\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_system = .*/atari800\_system = \"400\/800 \(OS B\)\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/BASIC\_VERSION=.*/BASIC\_VERSION=B/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/OS\_400\/800\_VERSION.*/OS\_400\/800\_VERSION=CUSTOM/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  else
    sed -i 's/atari800\_system = .*/atari800\_system = \"130XE \(128K\)\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_system = .*/atari800\_system = \"130XE \(128K\)\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_system = .*/atari800\_system = \"130XE \(128K\)\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/BASIC\_VERSION=.*/BASIC\_VERSION=AUTO/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/OS\_400\/800\_VERSION.*/OS\_400\/800\_VERSION=CUSTOM/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  fi

  # the script presumes that you have set up /opt/retropie/configs/atari800/emulators.cfg
  # to contain four additional emulators. We use the emulators solely to pick which
  # artifacting mode to set the configs to; they actually all run lr-atari800.
  #
  # You can edit this script to work for the standalone atari800 emulator as well,
  # just remove the "lr-" prefix from everything here, and from the emulators.cfg entries.

  if [ $emu == "lr-atari800" ]; then
    # lr-atari800 will have defaults of NTSC and artifacting off
    echo "Launching lr-atari800 with no artifacting." >&2
    sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"disabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"disabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"disabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/ARTIFACT\_NTSC=.*/ARTIFACT\_NTSC=NONE/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/ARTIFACT\_NTSC\_MODE=./ARTIFACT\_NTSC\_MODE=0/g' /opt/retropie/configs/atari800/lr-atari800.cfg

  elif [ $emu == "lr-atari800-ctia" ]; then
      # lr-atari800-ctia will have defaults of NTSC and artifacting set to CTIA (mode 4)
    echo "Launching with CTIA artifacting." >&2
    sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
      sed -i 's/ARTIFACT\_NTSC=.*/ARTIFACT\_NTSC=NTSC\-OLD/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/ARTIFACT\_NTSC\_MODE=./ARTIFACT\_NTSC\_MODE=4/g' /opt/retropie/configs/atari800/lr-atari800.cfg

  elif [ $emu == "lr-atari800-gtia" ]; then
    # lr-atari800-gtia will have defaults of NTSC and artifacting set to GTIA (mode 3)
    echo "Launching with GTIA artifacting." >&2
    sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/ARTIFACT\_NTSC=.*/ARTIFACT\_NTSC=NTSC\-OLD/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/ARTIFACT\_NTSC\_MODE=./ARTIFACT\_NTSC\_MODE=3/g' /opt/retropie/configs/atari800/lr-atari800.cfg

  elif [ $emu == "lr-atari800-artifacting1" ]; then
    # lr-atari800-artifacting1 will have defaults of NTSC and artifacting set to brown/blue 1 (mode 1)
    echo "Launching with mode 1 artifacting." >&2
    sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/ARTIFACT\_NTSC=.*/ARTIFACT\_NTSC=NTSC\-OLD/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/ARTIFACT\_NTSC\_MODE=./ARTIFACT\_NTSC\_MODE=1/g' /opt/retropie/configs/atari800/lr-atari800.cfg

  elif [ $emu == "lr-atari800-artifacting2" ]; then
    # lr-atari800-artifacting2 will have defaults of NTSC and artifacting set to brown/blue 2 (mode 2)
    echo "Launching with mode 2 artifacting." >&2
    sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"enabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/ARTIFACT\_NTSC=.*/ARTIFACT\_NTSC=NTSC\-OLD/g' /opt/retropie/configs/atari800/lr-atari800.cfg
    sed -i 's/ARTIFACT\_NTSC\_MODE=./ARTIFACT\_NTSC\_MODE=2/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  fi

# that said, if the ROM is for a PAL system, we want to set the system to match as it
# may affect game timing.
#
# note that you can set the PAL artifacting mode via the F1 menu in the emulator
# and it should stick after you Save Configuration under Emulator Settings.

  if [[ $rom == *PAL* ]]; then
    echo "Software designed for PAL video." >&2
    sed -i 's/atari800\_ntscpal = .*/atari800\_ntscpal = \"PAL\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_ntscpal = .*/atari800\_ntscpal = \"PAL\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_ntscpal = .*/atari800\_ntscpal = \"PAL\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/DEFAULT\_TV\_MODE=.*/DEFAULT\_TV\_MODE=PAL/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  else
    # otherwise, turn it to NTSC
    sed -i 's/atari800\_ntscpal = .*/atari800\_ntscpal = \"NTSC\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
	sed -i 's/atari800\_ntscpal = .*/atari800\_ntscpal = \"NTSC\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
	sed -i 's/atari800\_ntscpal = .*/atari800\_ntscpal = \"NTSC\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
    sed -i 's/DEFAULT\_TV\_MODE=.*/DEFAULT\_TV\_MODE=NTSC/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  fi

# we want to handle the 5200 case; these should be artifacting off and NTSC, but the
# above may have left the configs set otherwise from the previous game.

elif [ $system == "atari5200" ]; then
  echo "Atari 5200 requested, disabling artifacting." >&2
  sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"disabled\"/g' /opt/retropie/configs/all/retroarch-core-options.cfg
  sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"disabled\"/g' /opt/retropie/configs/atari800/retroarch-core-options.cfg
  sed -i 's/atari800\_artifacting = .*/atari800\_artifacting = \"disabled\"/g' /opt/retropie/configs/atari5200/retroarch-core-options.cfg
  sed -i 's/ARTIFACT\_NTSC=.*/ARTIFACT\_NTSC=NONE/g' /opt/retropie/configs/atari800/lr-atari800.cfg
  sed -i 's/ARTIFACT\_NTSC\_MODE=./ARTIFACT\_NTSC\_MODE=0/g' /opt/retropie/configs/atari800/lr-atari800.cfg
else
  echo "Not an lr-atari800 system." >&2
fi
