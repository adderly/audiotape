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
import Ubuntu.Components.ListItems 0.1 as ListItem

import "../common"

Page {
    id: aboutPage

    title: i18n.tr("About")
    property string appName: "Audiotape " + "0.1"
    property string appCopyright: "(C)2013-2014 Stefano Verzegnassi"
    property string appLicense: i18n.tr("This software is released under a GPLv3 licence.\nSee the source code for more details.")

    UbuntuShape {
        id: logo
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; margins: units.gu(4) }
        height: (aboutPage.height - units.gu(16)) / 4
        width: height * 1.075630252
        image: Image { source: "../img/logo.png" }
    }

    Label {
        id: appName
        anchors { top: logo.bottom; horizontalCenter: parent.horizontalCenter; topMargin: units.gu(1) }
        text: aboutPage.appName
        horizontalAlignment: Text.AlignHCenter
        fontSize: "x-large"
    }

    Label {
        id: appCopyright
        anchors { top: appName.bottom; horizontalCenter: parent.horizontalCenter; margins: units.gu(1) }
        text: aboutPage.appCopyright
        horizontalAlignment: Text.AlignHCenter
        fontSize: "medium"
    }
    Label {
        id: appLicense
        anchors { top: appCopyright.bottom; horizontalCenter: parent.horizontalCenter; margins: units.gu(1) }
        text: aboutPage.appLicense
        horizontalAlignment: Text.AlignHCenter
        fontSize: "small"
    }

    Column {
        anchors { left: parent.left; right: parent.right; top: appLicense.bottom; margins: units.gu(2) }
        ListItem.Header { text: i18n.tr("Thanks to:") }
        ListItem.Subtitled {
            text: "Lucas Romero Di Benedetto"
            subText: i18n.tr("Application icon and 'RecordPage' UI design")
        }
    }


    tools: ToolbarItems {
        locked: true
        opened: true
    }

}
