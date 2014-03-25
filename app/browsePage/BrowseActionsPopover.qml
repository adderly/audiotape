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
import Ubuntu.Components.ListItems 0.1 as ListItem

Component {
    Popover {
        id: browsePopover

        Column {
            id: containerLayout
            anchors { left: parent.left; top: parent.top; right: parent.right }

            ListItem.Header {
                text: browsePage.selectedFile
                __foregroundColor: Theme.palette.normal.overlayText
            }

            ListItem.Standard {
                text: i18n.tr("Rename")
                __foregroundColor: Theme.palette.normal.overlayText

                onClicked: {
                    PopupUtils.close(browsePopover)
                    PopupUtils.open(renameFileDialog)
                }
            }

            ListItem.Standard {
                text: i18n.tr("Delete")
                __foregroundColor: Theme.palette.normal.overlayText

                onClicked: {
                    PopupUtils.close(browsePopover)
                    PopupUtils.open(deleteDialog)
                }
            }

            ListItem.Standard {
                text: i18n.tr("Cut")
                __foregroundColor: Theme.palette.normal.overlayText

                onClicked: {
                    PopupUtils.close(browsePopover)
                    folderModel.cutIndex(browsePage.selectedFileIndex)
                }
            }

            ListItem.Standard {
                text: i18n.tr("Copy")
                __foregroundColor: Theme.palette.normal.overlayText

                onClicked: {
                    PopupUtils.close(browsePopover)
                    folderModel.copyIndex(browsePage.selectedFileIndex)
                }
            }
        }
    }
}
