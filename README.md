# lr-atari800-runcommand-onstart
A helper script that automatically reconfigures lr-atari800 for OSa, BASIC, artifacting, and PAL

This script will:

* Automatically launch PAL games in PAL.
* Automatically enable BASIC for games that require it.
* Let you choose from the four NTSC artifacting modes at the runcommand menu by setting an emulator for a specific rom.
* Automatically set the system to OSa for games that require it.

## INSTALLATION

1. Back up these files, or live dangerously. No warranties express or implied, don't blame me, etc.
```
    /opt/retropie/configs/atari800/atari800.cfg
    /opt/retropie/configs/all/retroarch-core-options.cfg
    /opt/retropie/configs/atari800/emulators.cfg
```
2. Edit `opt/retropie/configs/atari800/emulators.cfg` so that it has four new emulators. Mine now looks like this. The names matter.

```
  lr-atari800 = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-atari800/atari800_libretro.so --config /opt/retropie/configs/atari800/retroarch.cfg %ROM%"
  lr-atari800-ctia = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-atari800/atari800_libretro.so --config /opt/retropie/configs/atari800/retroarch.cfg %ROM%"
  lr-atari800-gtia = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-atari800/atari800_libretro.so --config /opt/retropie/configs/atari800/retroarch.cfg %ROM%"
  lr-atari800-artifacting1 = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-atari800/atari800_libretro.so --config /opt/retropie/configs/atari800/retroarch.cfg %ROM%"
  lr-atari800-artifacting2 = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-atari800/atari800_libretro.so --config /opt/retropie/configs/atari800/retroarch.cfg %ROM%"
  default = "lr-atari800"
```

3. Ensure that your Atari 8-bit roms follow the naming convention where you see (PD)(GB)[k-file][BASIC] etc in the filenames. For example:

```
  Dreadnought Megastars (1990)(Byte Back)(PAL)(GB)[k-file].atr  // this game will launch in PAL
  Beer Shot (1994)(Bednar, Kamil)(PD)[BASIC].atr // this game will enable BASIC
  Head over Heels (19xx)(Hit Squad)(GB)[h Homesoft][k-file].atr // this game will run with default of no BASIC and NTSC
  Ice Cap (19xx)(MacIlwee, Steven)(GB)[req OSa].atr  // this game will run on a 400/800 with OSa
  Galactic Quest (1981)(Crystalware)(US)[req OSa][BASIC].atr // this game will set the system to 400/800 OSa, and will also set BASIC to Rev. A 
```

4. Obtain a copy of the BIOS for Atari BASIC Revision A. This is needed for games that require OSa and happen to be in BASIC. Revision A BASIC has an md5 of `a4dc52536d526ecc51ea857b9fa2b90f` and is not typically called ATARIBAS.ROM. Place it in ~/RetroPie/BIOS -- be sure to give it a different filename than the normal Atari BASIC BIOS. Either add this filename to atari.cfg like this:

```
  ROM_BASIC_A=/home/pi/RetroPie/BIOS/BASIC Revision A (19xx)(Atari)(400-800).rom
```

Or go into the emulator menu and search the ROM system directory again, and then save the configuration file. Verify that on the menu, you are able to select Basic Rev. A.

5. Edit `/opt/retropie/configs/all/runcommand-onstart.sh` to include this script. Note that if you already have this script, you only need to insert the part starting at # apply Atari 8-bit specific patches...


6. Test!

* Try a game like Crush, Crumble and Chomp. It normally would not load because it requires BASIC to be enabled. Now it will. It might need you to hit the fire button when it first starts and sits at the blue screen.
* But it looks ugly! Yup, it needs artifacting.
* Exit the game, and relaunch it. Now enter the runcommand menu by tapping space bar or a button.
* Leave option 1, "Select default emulator for atari800," set at lr-atari800.
* Select option 2, "Select emulator for ROM." You should have several new options there. Select lr-atari800-artifacting1
* Exit without launching (if you just launch, the setting won't apply until the next time, for some reason)
* Launch the game again... you have blue water!
* Try Drol, also set to artifacting1. You should have red scorpions.
* Try Lode Runner with artifacting1. You should have blue bricks.
* Try Choplifter (not "Choplifter!" which is the color XE cart, but the original Broderbund one), with artifacting1. Dark blue sky, green ground.
* Try Micro League Baseball set to lr-atari800-ctia... the outfield should be green.
* Try Mr. Do! set to artifacting2. Your lives at the bottom of the screen should be red just like your guy in the playfield.
* Try Bug Off using lr-atari800-gtia. The flower stems and leaves will be green.
* Try Head Over Heels. This PAL game should be crisp and clear with no artifacts.
* Try Clonus, Micro Chess, TwoGun, IceCap, or another OSa game. The game should boot.

Enjoy the more authentic Atari 8-bit experience!
