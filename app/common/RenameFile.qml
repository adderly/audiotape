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
import Ubuntu.Components.Popups 0.1

Column {
    id: renameFile
    property string filePath

    spacing: units.gu(3)

    function getFileName(filePath) {
        return filePath.substr(filePath.lastIndexOf("/") + 1)
    }

    Row {
        id: renameItem
        spacing: units.gu(1)
        width: parent.width

        TextField {
            id: renameFileField
            width: parent.width - extensionFileLabel.width - units.gu(1)

            placeholderText: i18n.tr("Type to rename file...")
            hasClearButton: true

            inputMethodHints: { Qt.ImhPreferLowercase; Qt.ImhNoPredictiveText }

            onTextChanged: {
                // Disable save button to prevent invalid actions
                saveFileButton.enabled = false

                // Check if user has typed invalid chars
                if (checkInvalidChars(renameFileField.text) === true) {
                    workaroundLabel.visible = false
                    invalidCharWarning.visible = true
                } else {
                    invalidCharWarning.visible = false

                    // Without checking up on textField.text = "", it returns that a folder already exist)
                    if (utils.checkFileExists(root.appFolder + "/" + renameFileField.text + extensionFileLabel.text) === true && renameFileField.text !== "") {
                        workaroundLabel.visible = false
                        overwritingWarning.visible = true
                    } else {
                        overwritingWarning.visible = false
                        saveFileButton.enabled = true
                    }
                }
            }

            function checkInvalidChars(text) {
                // List of chars that are not allowed. This includes chars from Linux and MS-Windows, in order to make files readable on any platform.
                var chars = ["/", "\\", ">", "<", "*", ".", ",", "?", "|", ":", ";", "\""]
                var index;

                // Count of all the invalid chars found.
                var count = 0;

                for (index = 0; index < chars.length; index++) {
                    if (text.indexOf(chars[index]) !== -1)
                        count++;
                }

                // "False" means there's no invalid char in the string
                return count > 0 ? true : false;
            }
        }

        Label {
            id: extensionFileLabel
            anchors.verticalCenter: renameFileField.verticalCenter
            text: (utils.getFileCompleteSuffixFromPath(filePath) === "") ? "" : "." + utils.getFileCompleteSuffixFromPath(filePath)
        }
    }



    Row {
        id: buttonsItem
        spacing: units.gu(1)
        width: parent.width
        height: units.gu(4)

        Button {
            id: cancelButton
            height: parent.height
            text: i18n.tr("Cancel")
            gradient: UbuntuColors.greyGradient
            onClicked: PopupUtils.close(renameFile.parent.parent.parent)
        }

        Button {
            id: saveFileButton
            height: parent.height
            text: i18n.tr("Rename")
            width: parent.width - cancelButton.width - units.gu(1)

            onClicked: {
                if (renameFileField.text !== "")
                    utils.renameFile(filePath, renameFileField.text)

                PopupUtils.close(renameFile.parent.parent.parent)
            }
        }
    }

    Label { id: workaroundLabel; text: "" }

    Item {
        id: invalidCharWarning
        visible: false
        anchors { top: buttonsItem.bottom; left: parent.left; right: parent.right; topMargin: units.gu(1) }

        Label {
            anchors.fill: parent
            fontSize: "small"
            text: i18n.tr("/ \\ > < * . , ? ” | : ; are not allowed.")
        }
    }

    Item {
        id: overwritingWarning
        visible: false
        anchors { top: buttonsItem.bottom; left: parent.left; right: parent.right; topMargin: units.gu(1) }

        Label {
            anchors.fill: parent
            fontSize: "small"
            text: i18n.tr("A file with the same name already exists.")
        }
    }
}
