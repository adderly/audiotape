/*
  This file is part of Audiotape - An audio recorder for Ubuntu Touch.
  Copyright (C) 2014 Stefano Verzegnassi

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

import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

Dialog {
    id: dialogue

    property alias selectedIndex: selector.selectedIndex
    property alias model: selector.model

    // Is it scrollable?
    OptionSelector {
        id: selector
        expanded: true
    }

    Button {
        text: i18n.tr("Close")
        width: parent.width
        onClicked: PopupUtils.close(dialogue)
    }
}
