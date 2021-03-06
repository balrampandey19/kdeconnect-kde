/*
 * This file is part of KDE Telepathy Chat
 *
 * Copyright (C) 2015 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import org.kde.people 1.0
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kdeconnect.sms 1.0

Kirigami.ScrollablePage
{
    id: page
    property alias personUri: person.personUri
    readonly property QtObject person: PersonData {
        id: person
    }
    property QtObject device
    property string conversationId

    property string phoneNumber
    title: person && person.name ? i18n("%1: %2", person.name, phoneNumber) : phoneNumber

    ListView {
        model: QSortFilterProxyModel {
            id: model
            sortOrder: Qt.AscendingOrder
            sortRole: ConversationModel.DateRole
            sourceModel: ConversationModel {
                deviceId: device.id()
                threadId: page.conversationId
            }
        }

        spacing: Kirigami.Units.largeSpacing

        delegate: ChatMessage {
            messageBody: model.display
            sentByMe: model.fromMe
            dateTime: new Date(model.date)
        }

        // Set the view to start at the bottom of the page and track new elements if it was not manually scrolled up
        currentIndex: atYEnd ?
                        count - 1 :
                        currentIndex
    }

    footer: RowLayout {
        enabled: page.device
        TextField {
            id: message
            Layout.fillWidth: true
            placeholderText: i18n("Say hi...")
            onAccepted: {
                console.log("sending sms", page.phoneNumber)
                model.sourceModel.sendReplyToConversation(message.text)
                text = ""
            }
        }
        Button {
            text: "Send"
            onClicked: {
                message.accepted()
            }
        }
    }
}
