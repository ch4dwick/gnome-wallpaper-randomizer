# gnome-wallpaper-randomizer
A side project I had after I got inspired by the multiple beautiful Neo Tokyo wallpapers I found. Too many of them and not enough time to see them so I just thought,: "Hey, let's use them all!"

## Installation
You don't need root access to use this script.
Put the script anywhere in your home folder.
Make it executable: 
```sh
chmod +x gnome-wallpaper-randomizer.sh
```
Add to your personal cron. 
```sh
crontab -e
```

Sample schedule to change the wallpaper every minute and piping any output to syslog.
```
*/1 * * * * /home/chad/gnome-background-switcher.sh "/path/to/wallpapers" | systemd-cat -t gnome-wallpaper-randomizer
```
Caveat: Always test this script in the cron not on your shell as the environments for cron and shell are different.

## Some assumptions
Target folder exists and is not empty.
The contents of the folder are all image types. If there are non-images, it will probably break.

## References
- Random array element picker: https://stackoverflow.com/questions/2388488/how-to-select-a-random-item-from-an-array-in-shell
- Nuanced change in Ubuntu 22.04 regarding picture-uri/picture-uri-dark: https://askubuntu.com/questions/66914/how-to-change-desktop-background-from-command-line-in-unity