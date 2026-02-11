/*
    SPDX-FileCopyrightText: 2016 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.5 as Kirigami
import "private" as Private
import io.zynthbox.ui 1.0 as ZUI

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    leftPadding: background ? background.leftMargin : 4
    topPadding:  background ? background.topMargin : 4
    rightPadding:  background ?  background.rightMargin : 4
    bottomPadding:  background ? background.bottomMargin : 4

    icon.color: control.color
    icon.height: 16
    icon.width: 16

    spacing: PlasmaCore.Units.smallSpacing

    hoverEnabled: !Kirigami.Settings.tabletMode

    Kirigami.MnemonicData.enabled: control.enabled && control.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.SecondaryControl
    Kirigami.MnemonicData.label: control.text

    readonly property color defaultColor : control.pressed || control.checked ?  Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
    property color color :  ZUI.Theme.ghostButton ? control.ghostColor : control.defaultColor
    readonly property color ghostColor : control.pressed || control.checked || control.highlighted?  Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
    property bool showIndicator : false
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(control.text))
        sequence: control.Kirigami.MnemonicData.sequence
        onActivated: control.clicked()
    }

    PlasmaCore.ColorScope.inherit: flat
    PlasmaCore.ColorScope.colorGroup: flat && parent ? parent.PlasmaCore.ColorScope.colorGroup : PlasmaCore.Theme.ButtonColorGroup

    contentItem: Loader {
        sourceComponent: control.display == T.Button.TextUnderIcon ? _vLayout : _hLayout
    }

    indicator: Kirigami.Icon {
        source: Qt.resolvedUrl("images/arrow-down.svg")
        color: control.color
        height: 8
        width: 8
        visible: control.showIndicator

        x: control.width - width - 4
        y: control.height - (height) - 4
    }
    

    Component {
        id: _vLayout
        Private.ButtonContent {
            labelText: control.Kirigami.MnemonicData.richTextLabel
        }
    }

    Component {
        id: _hLayout

        Item {
            implicitWidth: _layout.implicitWidth
            implicitHeight: Kirigami.Units.gridUnit 
            opacity: enabled ? 1 : 0.5

            RowLayout {
                id: _layout
                width: control.display !== T.Button.TextUnderIcon && icon.visible ? Math.min(parent.width, implicitWidth) : parent.width
                height: parent.height
                spacing:2
                anchors.centerIn: parent
                Kirigami.Icon {
                    id: icon
                    Layout.alignment: Qt.AlignCenter
                    source: control.icon ? ( control.icon.name || control.icon.source) : ""
                    color: ZUI.Theme.ghostButton ? control.icon.color : control.color
                    implicitHeight: control.icon.height
                    implicitWidth: control.icon.width
                    visible: icon.source.length > 0 && control.display !== T.Button.TextOnly
                }

                T.Label {
                    id: _label
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: text.length > 0 && control.display !== T.Button.IconOnly
                    text: control.text
                    font: control.font
                    color: control.color
                    horizontalAlignment: control.display !== T.Button.TextUnderIcon && icon.visible ? Text.AlignLeft : Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
        }
    }

    background: Private.ButtonBackground 
    {}
}
