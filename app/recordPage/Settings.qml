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
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

import "../common"

Flickable {
    id: flickable
    // In order to prevent actions from user while recording audio.
    enabled: !isRecording

    anchors.fill: parent
    contentHeight: content.height
    interactive: contentHeight > height
    clip: true

    Column {
        id: content
        anchors { top: parent.top; left: parent.left; right: parent.right; margins: units.gu(2) }

        // *** CODEC ***
        ListItem.SingleValue {
            id: codecItem
            text: i18n.tr("Codec")
            value: root.favCodec
            onClicked: PopupUtils.open(codecPopup);
        }
        Component {
            id: codecPopup
            SettingsPopup {
                title: i18n.tr("Choose a codec")
                selectedIndex: root.favCodecIndex
                model: root.supportedCodecs
                onSelectedIndexChanged: {
                    root.favCodecIndex = selectedIndex
                    var set = JSON.parse(JSON.stringify(settings.contents))
                    set.favCodec = root.supportedCodecs[selectedIndex]
                    settings.contents = set
                    root.getCodec()
                }
            }
        }

        // *** QUALITY ***
        ListItem.SingleValue {
            id: qualityItem
            text: i18n.tr("Quality")
            value: getQualityName(root.favQuality)
            onClicked: PopupUtils.open(qualityPopup);

            function getQualityName(n) {
                switch (n) {
                case 0:
                    return i18n.tr("Very low")
                case 1:
                    return i18n.tr("Low")
                case 2:
                    return i18n.tr("Normal")
                case 3:
                    return i18n.tr("High")
                case 4:
                    return i18n.tr("Very high")
                }
            }
        }
        Component {
            id: qualityPopup
            SettingsPopup {
                title: i18n.tr("Set quality")
                selectedIndex: root.favQuality
                model: [i18n.tr("Very low"),
                    i18n.tr("Low"),
                    i18n.tr("Normal"),
                    i18n.tr("High"),
                    i18n.tr("Very high")]
                onSelectedIndexChanged: {
                    root.favQuality = selectedIndex
                    var set = JSON.parse(JSON.stringify(settings.contents))
                    set.favQuality = selectedIndex
                    settings.contents = set
                }
            }
        }

        // *** VOLUME ***
        ListItem.Standard {
            id: listItem_preamp

            text: i18n.tr("Volume")

            control: Slider {
                id: preampSlider
                width: units.gu(21)
                anchors.verticalCenter: parent.verticalCenter

                value: root.preamp
                minimumValue: 50
                maximumValue: 150
                onValueChanged: {
                    var set = JSON.parse(JSON.stringify(settings.contents))
                    set.preamp = value
                    settings.contents = set
                }
            }
        }

        ListItem.Standard {
            text: i18n.tr("About Audiotape...")
            onClicked: pageStack.push(aboutPage)
        }

    }
}




