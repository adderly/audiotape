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
import QtMultimedia 5.0
import Ubuntu.Components.Popups 0.1

import "../common"

Page {
    title: i18n.tr("Play")

    property string audioName
    property string audioPath

    Audio {
        id: playerAudio
        source: "file://" + audioPath
        autoPlay: true

        onError: PopupUtils.open(Qt.resolvedUrl("../common/InfoDialog.qml"), playback, {title: i18n.tr("Error!"), description: playerAudio.errorString})
        onDurationChanged: seekSlider.maximumValue = playerAudio.duration
    }

    Item {
        id: durationItem
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: units.gu(4) }
        height: positionAudio.height + fileNameLabel.height + fileNameLabel.anchors.margins

        ImprovedLabel {
            id: positionAudio
            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
            font.weight: Font.Light
            improvedSize: "xxx-large"
            text: root.convertDurationToHHMMSS(playerAudio.position)
        }

        Label {
            id: fileNameLabel
            anchors { top: positionAudio.bottom; horizontalCenter: parent.horizontalCenter; margins: units.gu(2) }
            font.weight: Font.Light
            fontSize: "large"
            text: utils.getFileBaseNameFromPath(audioPath)
        }
    }

    Item {
        id: seekItem
        visible: false
        opacity: (visible == false) ? 0.0 : 1.0
        anchors { top: durationItem.bottom; left: parent.left; right: parent.right; margins: units.gu(2) }
        Behavior on opacity {
            PropertyAnimation { easing: UbuntuAnimation.StandardEasing }
        }

        Slider {
            id: seekSlider
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - units.gu(4)

            minimumValue: 0
            maximumValue: 100000
            function formatValue(v) {return root.convertDurationToHHMMSS(v)}

            onPressedChanged: if (!pressed) playerAudio.seek(value)

            Binding {
                target: seekSlider
                property: "value"
                value: playerAudio.position
                when: !seekSlider.pressed
            }
        }
    }

    Item {
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: units.gu(14) }

        Image {
            id: seekButton
            width: units.gu(4); height: width
            anchors { verticalCenter: playButton.verticalCenter; right: playButton.left; margins: units.gu(8) }
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: "../img/seek.png"

            MouseArea {
                anchors.fill: parent
                onClicked: seekItem.visible = !seekItem.visible
            }
        }

        UbuntuShape {
            id: playButton
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }

            color: "#eeeeee"
            radius: "medium"
            width: units.gu(10); height: width

            MouseArea {
                anchors.fill: parent
                onClicked: (playerAudio.playbackState === MediaPlayer.PlayingState) ?
                               playerAudio.pause() : playerAudio.play()

                Image {
                    anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }

                    width: units.gu(7); height: width
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    source: playerAudio.playbackState === MediaPlayer.PlayingState ? "../img/player-pause.png" : "../img/play.png"
                }
            }

            Image {
                id: stopButton
                width: units.gu(4); height: width
                anchors { verticalCenter: playButton.verticalCenter; left: playButton.right; leftMargin: units.gu(8) }

                fillMode: Image.PreserveAspectFit
                smooth: true
                source: "../img/player-stop.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (playerAudio.playbackState !== MediaPlayer.StoppedState)
                            playerAudio.stop()
                    }
                }
            }
        }
    }

    tools: ToolbarItems {
        locked: true
        opened: true
    }
}
