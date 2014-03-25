/*
  This file is part of Audiotape - An audio recorder for Ubuntu Touch.
  Copyright (C) 2013-2014 Stefano Verzegnassi

    This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License 3 as published by
  the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import Ubuntu.Components 0.1

Item {
    property string side: "left"    // "left" or "right"

    anchors {
        top: parent.top; bottom: parent.bottom
        right: side == "right" ? parent.right : undefined
        left: side == "left" ? parent.left : undefined
    }
    width: units.gu(35)

    Behavior on width {
        PropertyAnimation { duration: UbuntuAnimation.SlowDuration }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {position: 0.0; color: Qt.rgba(0.0, 0.0, 0.0, 0.0)}
            GradientStop {position: 0.9; color: Qt.rgba(0.0, 0.0, 0.0, 0.05)}
            GradientStop {position: 1.0; color: Qt.rgba(0.0, 0.0, 0.0, 0.1)}
        }
    }
}
