import QtQuick 2.4
import QtQuick.Controls 2.3

ServerForm {
    id: serverForm
    width: 600
    height: 60

    property string name: "test Server"
    property string serverId: "ecbc993c-5de5-4602-9a3e-61ee0247b142"
    property int player: 1
    property int playerMax: 4

    Rectangle {
        id: rectangle1
        x: 0
        width: parent.width
        height: 1
        color: "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Button {
        id: button
        x: 492
        y: 10
        text: qsTr("Se connecter") + rootItem.emptyString
        height: parent.height*0.6
        width: parent.height*1.5
        anchors.verticalCenterOffset: 0
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter

        background:
            Rectangle {
                anchors.fill: parent
                radius: 20
                color:  player<playerMax?(button.hovered?"#e98515":"#ffffff"):"#ffffff"
        }

        onHoveredChanged:
        {
            if(hovered)
                playSnap.play();
        }

        onClicked: {
            if(player<playerMax)
            {
                playClick.play();
                network.joinRoom(serverId);
                swipeHorizontalServeur.setCurrentIndex(2);
                room.host=false;
                room.name=name;
                room.roomId=serverId;
                room.player=player;
                room.playerMax=playerMax;
            }
        }

    }

    Text {
        id: text1
        y: 17
        width: 410
        height: 43
        color: "#ffffff"
        text: name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.verticalCenterOffset: 1
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12
    }

    Text {
        id: text2
        x: 424
        y: 10
        width: 73
        height: 40
        color: player<playerMax?"#3ff826":"#b31919"
        text: player + "/" + playerMax
        anchors.right: parent.right
        anchors.rightMargin: 103
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }
}
