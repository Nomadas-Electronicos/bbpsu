# **BBPSU Fuente de alimentación con respaldo de Batería**

El proyecto es una fuente para dar alimentación continua a dispositivos como:
- Ruteadores
- Modems
- Switches
- Hubs
- O cualquier dispositivo que requiera hasta 12V@2A de alimentación

El funcionamiento esta basado en un convertidor DC/DC de topología SEPIC. El monitoreo de la fuente se realiza por medio de un microcontrolador ATMega328 y un display LCD16x2(i2c)

El esquemático esta hecho en [Diptrace](www.diptrace.com) y el firmware en CodeVision.

Existen 2 versiones principales: La primera (bbpsu_mcu) tiene errores comentados en el respectivo post en [Nómadas Electrónicos](https://nomadaselectronicos.wordpress.com/2021/07/11/fuente-con-respaldo-de-bateria-para-ruteadores-switches-etc-sepic/). La segunda (bbpsu_mcu_v2) trata de corregir los errores mencionados, ademas de ser mas el punto de partida para ir mejorando el circuito y el firmware. Tambien hay una version "sencilla" (bbpsu) que no requiere microprocesador o programacion alguna, todo se configura con las resistencias variables del circuito.

Aunque el programa del microcontrolador esta hecho en CodeVision, no se descarta que en un futuro, se cambie a un compilador algo mas popular y/o accesible para toda persona que este interesada en el desarrollo del circuito.

También es posible que en un futuro se incorporen extras complementarios, como el diseño de alguna carcasa para impresion 3D, o algo asi.
