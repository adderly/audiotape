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

Component {
    id: createNewFolderDialog

    Dialog {
        id: createNewFolderDialogue
        title: i18n.tr("Create new folder")
        text: i18n.tr("Please type a name")

        TextField {
            id: createFolderField
            width: parent.width

            focus: true
            placeholderText: i18n.tr("Enter a valid name...")
            hasClearButton: true

            inputMethodHints: { Qt.ImhPreferLowercase; Qt.ImhNoPredictiveText }

            onTextChanged: {
                // Disable save button to prevent invalid actions
                createFolderButton.enabled = false

                // Check if user has typed invalid chars
                if (checkInvalidChars(createFolderField.text) === true) {
                    workaroundLabel.visible = false
                    invalidCharWarning.visible = true
                } else {
                    invalidCharWarning.visible = false

                    // Without checking up on textField.text = "", it returns that a folder already exist)
                    if (utils.checkFolderExists(folderModel.path + "/" + createFolderField.text) === true && createFolderField.text !== "") {
                        workaroundLabel.visible = false
                        overwritingWarning.visible = true
                    } else {
                        overwritingWarning.visible = false
                        createFolderButton.enabled = true
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

        Item { height: units.gu(3) }

        Row {
            id: buttonsItem
            spacing: units.gu(1)
            width: parent.width
            height: units.gu(4)

            Button {
                id: cancelButton
                height: parent.height
                text: "Cancel"
                color: Theme.palette.normal.base
                onClicked: PopupUtils.close(createNewFolderDialogue)
            }

            Button {
                id: createFolderButton
                height: parent.height
                text: "Create"
                width: parent.width - cancelButton.width - units.gu(1)

                onClicked: {
                    if (createFolderField.text !== "")
                        folderModel.mkdir(createFolderField.text)

                    PopupUtils.close(createNewFolderDialogue)
                }
            }
        }

        Label { id: workaroundLabel; text: "" }

        Item {
            id: invalidCharWarning
            anchors { top: buttonsItem.bottom; left: parent.left; right: parent.right; topMargin: units.gu(1) }
            visible: false

            Label {
                anchors.fill: parent
                fontSize: "small"
                text: i18n.tr("/ \\ > < * . , ? ” | : ; are not allowed.")
            }
        }

        Item {
            id: overwritingWarning
            anchors { top: buttonsItem.bottom; left: parent.left; right: parent.right; topMargin: units.gu(1) }
            visible: false

            Label {
                anchors.fill: parent
                fontSize: "small"
                text: i18n.tr("A folder with the same name already exists.")
            }
        }
    }
}
