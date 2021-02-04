ifconfig -a
ifconfig wlp2s0 up
wpa_passPhrase CSTH-AX_5G CSTH636797 > /etc/wpa_supplicant/CSTH-AX_5G.conf
wpa_supplicant -i wlp2s0 -c /etc/wpa_supplicant/CSTH-AX_5G.conf -B
#wpa_passPhrase CSTH-AX_5G CSTH636797 > /etc/wpa_supplicant/wpa_supplicant-wlp2s0.conf
#wpa_supplicant -i wlp2s0 -c /etc/wpa_supplicant/wpa_supplicant-wlp2s0.conf -B
dhclient wlp2s0
ifconfig
iwconfig


