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
import Ubuntu.Layouts 0.1
import org.nemomobile.folderlistmodel 1.0

import "../common"

Tab {
    title: i18n.tr("Files")

    function getCategoryName(path) {
        if (path === root.appFolder)
            return i18n.tr("Uncategorized")
        else
            return path.replace(root.appFolder + "/", "")
    }

    page: Page {
        id: browsePage
        flickable: folderList

        // In order to prevent actions from user while recording audio.
        enabled: !isRecording

        property    string      selectedFile
        property    string      selectedFilePath
        property    int         selectedFileIndex
        property    bool        selectedIsDir

        property    bool        isSearchMode

        //TODO: Multi-selection

        Layouts {
            anchors.fill: parent
            layouts: [
                ConditionalLayout {
                    name: "wide"
                    when: isWide

                    Item {
                        anchors.fill: parent

                        ItemLayout {
                            item: "folderList"
                            anchors { top: parent.top; left: parent.left; right: sidebar.left; bottom: parent.bottom; margins: units.gu(2) }
                        }

                        Sidebar {
                            id: sidebar
                            side: "right"
                            width: units.gu(40)

                            Label {
                                anchors.centerIn: parent
                                text: "<b>TODO:</b> Add some content here..."
                            }
                        }
                    }
                }
            ]

            ListView {
                id: folderList
                Layouts.item: "folderList"
                anchors { fill: parent; margins: units.gu(2) }
                header: ListItem.Header {
                    text: browsePage.isSearchMode ? searchModel.count === 1 ? i18n.tr("1 file found")
                                                                            : i18n.tr("%1 files found").arg(folderList.count)
                                                  : getCategoryName(folderModel.path)
                }
            }
        }

        // Browse files
        FolderListModel {
            id: folderModel

            path: root.appFolder
            nameFilters: ["*.flac", "*.wav", "*.mp3", "*.ogg", "*.amr"]
            enableExternalFSWatcher: true
        }
        Component {
            id: folderDelegate
            FolderDelegate {}
        }

        // Search for a file
        FolderListModel {
            id: searchModel
            property var defaultFilters:
               ["*" + searchText.text + "*.flac",
                "*" + searchText.text + "*.wav",
                "*" + searchText.text + "*.mp3",
                "*" + searchText.text + "*.ogg",
                "*" + searchText.text + "*.amr"]

            path: root.appFolder
            showDirectories: true
            isRecursive: true
            nameFilters: defaultFilters
            enableExternalFSWatcher: true

        }
        Component { id: searchDelegate; SearchDelegate {} }

     
        states: [
            State {
                name: "searchModeON"
                when: browsePage.isSearchMode

                PropertyChanges {target: folderList; model: searchModel}
                PropertyChanges {target: folderList; delegate: searchDelegate}
            },

            State {
                name: "searchModeOFF"
                when: !browsePage.isSearchMode

                PropertyChanges {target: folderList; model: folderModel}
                PropertyChanges {target: folderList; delegate: folderDelegate}
            }
        ]

        tools: ToolbarItems {
            id: toolbar
            enabled: !isRecording

            back: ToolbarButton {
                visible: !browsePage.isSearchMode && (folderModel.path !== root.appFolder)
                iconSource: icon("keyboard-caps")  //FIXME: Need new icon
                text: i18n.tr("Up")
                onTriggered: folderModel.path = folderModel.parentPath
            }

            ToolbarButton {
                visible: folderModel.clipboardUrlsCounter !== 0 && !browsePage.isSearchMode
                iconSource: "../img/paste.png"  //FIXME: Need new icon
                text: i18n.tr("Paste (%1)").arg(folderModel.clipboardUrlsCounter)
                onTriggered: folderModel.paste()
            }

            ToolbarButton {
                visible: !browsePage.isSearchMode
                iconSource: "../img/newfolder.png"  //FIXME: Need new icon
                text: i18n.tr("New folder")
                onTriggered: PopupUtils.open(createNewFolderDialog)
            }

            ToolbarButton {
                iconSource: browsePage.isSearchMode ? icon("back") : icon("find")
                text: browsePage.isSearchMode ? i18n.tr("Close") : i18n.tr("Search")
                onTriggered: browsePage.isSearchMode = !browsePage.isSearchMode
            }

            TextField {
                id: searchText
                visible: browsePage.isSearchMode
                anchors.verticalCenter: parent.verticalCenter
                width: isWide ? units.gu(31) : implicitWidth

                placeholderText: i18n.tr("Search...")
                hasClearButton: true
            }
        }


        // *** DIALOGS AND POPOVERS ***
        DeleteDialog { id: deleteDialog }
        NewFolderDialog { id: createNewFolderDialog }
        BrowseActionsPopover { id: browseActionsPopover }
        Component {
            id: renameFileDialog
            Dialog {
                id: renameFileDialogue
                title: browsePage.selectedIsDir ? i18n.tr("Rename folder")
                                                : i18n.tr("Rename file")
                text: i18n.tr("Current name: ") + renameFile.getFileName(renameFile.filePath)

                RenameFile {
                    id: renameFile
                    filePath: browsePage.selectedFilePath
                }
            }
        }
    }
}
