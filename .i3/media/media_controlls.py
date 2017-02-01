#!/usr/bin/env python3

import dbus
from sys import argv, exit


class SimpleRhythmboxController:
    dbus_name = 'org.mpris.MediaPlayer2.rhythmbox'
    mpris_obj_path = '/org/mpris/MediaPlayer2'
    player_iface_path = 'org.mpris.MediaPlayer2.Player'

    class MethodNames:
        next = 'Next'
        previous = 'Previous'
        toggle = 'PlayPause'

    def __init__(self):
        self._bus = dbus.SessionBus()
        self._proxy = self._bus.get_object(self.dbus_name, self.mpris_obj_path)
        self._interface = dbus.Interface(self._proxy, self.player_iface_path)
        self._fetch_dbus_methods()

    def _fetch_dbus_methods(self):
        names = self.MethodNames

        self.next = self._interface.get_dbus_method(names.next)
        self.previous = self._interface.get_dbus_method(names.previous)
        self.toggle = self._interface.get_dbus_method(names.toggle)


default_controller = SimpleRhythmboxController

def usage():
    usage_str = "Usage: {} {{next|previous|toggle}}"
    usage_str = usage_str.format(argv[0])
    print(usage_str)

if __name__ == '__main__':
    if len(argv) < 2:
        usage()
        exit(1)

    controller = default_controller()

    if argv[1] == 'next':
        controller.next()
    if argv[1] == 'previous':
        controller.previous()
    if argv[1] == 'toggle':
        controller.toggle()
