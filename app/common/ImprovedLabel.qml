/*
 * Copyright (C) 2013-2014 Stefano Verzegnassi
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import Ubuntu.Components 0.1

/*!
    Example:
    \qml
        Label {
            text: "Hello, bigger world!"
            improvedSize: "xxx-large"
        }
    }
    \endqml
*/

Label {
    id: improvedLabel

    /*!
          The size of the text. One of the following strings (from smallest to largest):
            \list
              \li "xx-small"
              \li "x-small"
              \li "small"
              \li "medium"
              \li "large"
              \li "x-large"
              \li "xx-large"
              \li "xxx-large"
            \endlist
            Just like the original Ubuntu SDK Label, default value is "medium".
          */
    property string improvedSize: "medium"
    font.pixelSize: getPixelSize(improvedSize)

    function getPixelSize(size) {
        var modularScale = 1.0;

        switch(size) {
        case "xxx-large":
            modularScale = 3.434;
            break;
        case "xx-large":
            modularScale = 2.828;
            break;
        case "x-large":
            modularScale = 2.328;
            break;
        case "large":
            modularScale = 1.414;
            break;
        case "medium":
            break;  // We have already set modularScale to 1.0
        case "small":
            modularScale = 0.857;
            break;
        case "x-small":
            modularScale = 0.707;
            break;
        case "xx-small":
            modularScale = 0.606;
            break;
        }

        return Math.round(modularScale * FontUtils.sizeToPixels("medium"));
    }
}
