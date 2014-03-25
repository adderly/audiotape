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
import Ubuntu.Components.Popups 0.1
import Ubuntu.Layouts 0.1
import Recorder 0.1

import "../common"

Tab {
    title: i18n.tr("Record")

    page: Page {
        id: recordPage
        flickable: null

        OnCompletedDialog { id: onCompletedDialog }

        AudioRecorder {
            id: recorder
            path: root.appFolder + "/" + getCurrentDateTime()
            codec: root.favCodec
            input: "alsa:default"
            quality: root.favQuality
            volume: root.preamp/100

            onErrorChanged: recordPage.recorderError()
            onStateChanged: {
                switch(state) {
                case 1:
                    isRecording = true;
                    sliderButton.knobImageUrl = "../img/pause.png";
                    break;
                case 2:
                    sliderButton.knobImageUrl = "../img/resume.png";
                    break;
                case 0:
                    isRecording = false;
                    PopupUtils.open(onCompletedDialog);
                    sliderButton.knobImageUrl = "../img/rec.png";
                    break;
                }
            }

            Component.onCompleted: {
                console.log("Supported inputs: ", recorder.getAudioInputs())
                root.supportedCodecs = getSupportedCodecs();
            }
        }

        //FIXME: Sliderbutton reset
        function recorderError() {
            sliderButton.reset()
            sliderButton.knobImageUrl = "../img/rec.png"
            PopupUtils.open(Qt.resolvedUrl("../common/InfoDialog.qml"), recordPage,
                            {title: i18n.tr("Error!"), description: recorder.errorString})
        }

        Layouts {
            anchors.fill: parent
            layouts: [
                ConditionalLayout {
                    name: "wide"
                    when: isWide

                    Item {
                        anchors.fill: parent

                        ItemLayout {
                            item: "widgetContainer"
                            // FIXME: anchors. Offsets are just random values.
                            anchors { centerIn: parent; verticalCenterOffset: - (parent.height - height - toolbar.height*2) / 2 ; horizontalCenterOffset: - (sidebar.width - durationLabel.width) }
                        }

                        Sidebar {
                            id: sidebar
                            side: "right"
                            width: units.gu(40)

                            Settings {}
                        }
                    }
                }
            ]

            Column {
                id: widgetContainer
                Layouts.item: "widgetContainer"

                anchors.centerIn: parent
                spacing: units.gu(4)

                ImprovedLabel {
                    id: durationLabel
                    font.weight: Font.Light
                    improvedSize: "xxx-large"
                    text: convertDurationToHHMMSS(recorder.duration)
                }

                //TODO: Add smoother transition when knobImage is changing
                SliderButton {
                    id: sliderButton
                    anchors.horizontalCenter: durationLabel.horizontalCenter
                    width: height / 3

                    //TODO: Use an Image object, instead of setting the source property
                    btDragImageUrl: "../img/stop.png"
                    knobImageUrl: "../img/rec.png"

                    // Start recording
                    onTbDragCompleted: {
                        checkCreateAppDir()
                        recorder.start()
                    }

                    onBtDragCompleted: recorder.stop()

                    onClicked: {
                        if (recorder.state == 1) {   // While recording, to pause recording
                            recorder.pause()
                        } else if (recorder.state == 2) {    // While paused, to resume recording
                            recorder.resume()
                        }
                    }
                }
            }
        }

        tools: ToolbarItems {
            id: toolbar
            locked: !isWide
            opened: !isWide

            ToolbarButton {
                enabled: !isWide
                visible: !isWide
                iconSource: icon("settings")
                text: i18n.tr("Settings")
                onTriggered: pageStack.push(settingsPage)
            }
        }
    }
}
