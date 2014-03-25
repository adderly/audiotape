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

ListItem.Subtitled {
    id: searchItem

    text: highlightText(fileName, searchText.text)
    subText: i18n.tr("Category") + ": " + getCategoryName(filePath)

    onClicked: pageStack.push(playbackPage, {audioPath: filePath})
    onPressAndHold: {
        browsePage.selectedFile = model.fileName
        browsePage.selectedFileIndex = model.index
        browsePage.selectedFilePath = model.filePath
        browsePage.selectedIsDir = model.isDir
        PopupUtils.open(browseActionsPopover)
    }

    function highlightText(text, partToHighlight) {
        var n = text.toLowerCase().indexOf(partToHighlight.toLowerCase());
        var length = partToHighlight.length;
        return text.substring(0, n) + "<b>" + text.substring(n, n + length) + "</b>" + text.substring(n + length, text.length);
    }

    function getCategoryName(path) {
        path = path.substring(root.appFolder.length + 1, path.lastIndexOf('/'))
        return (path === "/") ? i18n.tr("Uncategorized") : path
    }
}
