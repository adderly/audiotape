/*
  This file is part of Audiotape - An audio recorder for Ubuntu Touch.
  Copyright (C) 2013-2014 Stefano Verzegnassi

    Audiotape is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License 3 as published by
  the Free Software Foundation.

    Audiotape is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import Ubuntu.Components 0.1
import U1db 1.0 as U1db
import Recorder 0.1

import "recordPage"
import "browsePage"

MainView {
    id: root
    objectName: "Audiotape"
    applicationName: "com.ubuntu.developer.verzegnassi.audiotape"

    property string appFolder: utils.getHomePath() + "/Audiotape"

    anchorToKeyboard: true

    width: units.gu(50)     //120
    height: units.gu(75)
    StateSaver.properties: "width, height"

    // Colors from Lucas Romero's UI concept for Audiotape
    headerColor: "#CC181E"
    backgroundColor: "#5E0A0D"
    footerColor: "#48080B"

    property var supportedCodecs

    property string favCodec
    property int favCodecIndex  // This is set by getCodec()
    property int favQuality: settings.contents.favQuality
    property int preamp: parseFloat(settings.contents.preamp)

    property bool isRecording

    // UI convergence
    //TODO: Convergence using Layouts
    property bool isWide: width >= units.gu(80)

    Component.onCompleted: {
        checkCreateAppDir()
        getCodec()

        if (width < units.gu(50) || height < units.gu(75)) {
            width = units.gu(50);
            height = units.gu(75);
        }
    }
    
    function icon(iconName) {
        return "/usr/share/icons/ubuntu-mobile/actions/scalable/" + iconName + ".svg"
    }

    function getCurrentDateTime() {
        var currentdate = new Date();
        return currentdate.getFullYear().toString() + (currentdate.getMonth()+1) + currentdate.getDate() + "-" +
                + currentdate.getHours() + currentdate.getMinutes() + (currentdate.getSeconds() < 10 ? "0" + currentdate.getSeconds() : currentdate.getSeconds());
    }

    function convertDurationToHHMMSS(duration) {
        duration = parseInt(duration / 1000)
        var hours = parseInt( duration / 3600 ) % 24;
        var min = parseInt( duration / 60 ) % 60;
        var sec = duration % 60;

        return (hours == 0 ? "" : hours + ":") + (min < 10 ? "0" + min : min) + ":" + (sec < 10 ? "0" + sec : sec);
    }

    Utils { id: utils }
    function checkCreateAppDir() {
        if (!utils.checkFolderExists(appFolder)) {
            utils.mkPath(appFolder)
        }
    }


    // *** SETTINGS ***
    U1db.Database {
        id: db
        path: "settings"
    }

    U1db.Document {
        id: settings
        database: db
        docId: 'settings'
        create: true
        defaults: {
            favCodec: ""
            favQuality: "4"
            preamp: "100"
        }
    }

    function getCodec() {
        favCodec = settings.contents.favCodec

        var ii=supportedCodecs.length;
        var x=0;

        for (var i=0; i<ii; i++) {
            var codec = supportedCodecs[i];
            if (favCodec !== codec) {
                x++;
            }
        }

        if (x === ii) {     // This means that favCodec is not one of supported codecs
            favCodecIndex = 0;
            var set = JSON.parse(JSON.stringify(appSetting.contents))
            set.favCodec = supportedCodecs[0];
            settings.contents = set
        }
    }


    // *** PAGESTACK ***
    PageStack {
        id: pageStack
        Component.onCompleted:push(tabs)

        Tabs {
            id: tabs
            tabBar.visible: pageStack.depth == 1

            RecordPage {}
            BrowsePage {}
        }

        Component {
            id: aboutPage
            AboutPage {}
        }

        Component {
            id: playbackPage

            PlaybackPage {}
        }


        Component {
            id: settingsPage
            Page {
                title: i18n.tr("Settings")
                flickable: settings

                Settings {
                    id: settings
                }

                tools: ToolbarItems {
                    locked: true
                    opened: true
                }
            }
        }
    }

}

