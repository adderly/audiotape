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
    id: deleteDialog
    Dialog {
        id: deleteDialogue
        title: browsePage.selectedIsDir ? i18n.tr("Delete folder")
                                        : i18n.tr("Delete file")
        text: browsePage.selectedIsDir ? i18n.tr("Are you sure you want to delete this folder?")
                                       : i18n.tr("Are you sure you want to delete this file?")

        Button {
            text: i18n.tr("Cancel")
            gradient: UbuntuColors.greyGradient
            onClicked: PopupUtils.close(deleteDialogue)
        }
        Button {
            text: i18n.tr("Delete")
            onClicked: {
                folderModel.rm(browsePage.selectedFilePath)
                PopupUtils.close(deleteDialogue)
            }
        }

        Text {
            id: warningText
            visible: browsePage.selectedIsDir

            width: parent.width
            wrapMode: Text.WordWrap

            font.pixelSize: FontUtils.sizeToPixels("medium")
            font.family: "Ubuntu"
            color: Theme.palette.selected.backgroundText

            text: i18n.tr("If the folder contains some files, they will be PERMANENTLY deleted.")
        }
    }
}
