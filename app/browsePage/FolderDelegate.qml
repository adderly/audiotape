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

import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

ListItem.Subtitled {
    text: fileName
    subText: isDir ? "" : creationDate()
    progression: isDir

    onClicked: {
        // TODO: Waiting for the toolkit to support MouseEvents...
        /*if (mouse.button == Qt.RightButton)
            openActions()
        else*/
            isDir ? folderModel.path = filePath
                  : pageStack.push(playbackPage, {audioPath: filePath, audioName: fileName})
    }
    onPressAndHold: openActions()

    function openActions() {
        browsePage.selectedFile = model.fileName
        browsePage.selectedFileIndex = model.index
        browsePage.selectedFilePath = model.filePath
        browsePage.selectedIsDir = model.isDir
        PopupUtils.open(browseActionsPopover)
    }

    function creationDate() {
        return Qt.formatDateTime(model.creationDate, "yyyy/MM/dd hh:mm");
    }
}
