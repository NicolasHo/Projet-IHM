import QtQuick 2.7
import QtQuick.Window 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import game.backend 1.0
import game.handmodel 1.0


GameForm {
    id: gameForm
    width: 1280
    height: 800

    property bool myturn: false

    Connections{
        target: game
        onCurCardChange:
        {
            print("onCurCardChange");
            playCardBt.changecrd(cl, index, value,0);
        }
        onSelectColor:
        {
            changeColor.visible=true;
        }

        onGameEnd:
        {
            print("test end");
            rectangleEnd.end=me;
            rectangleEnd.visible=true;
        }

        onMyTurn:
        {
            print("onMyTurn");
            myturn=true;
        }
        onPlayCardOk:
        {
            print("onPlayCardOk");
            gameForm.myturn=false;
        }

        onChangeColor:
        {
            print("onChangeColor");
            card1.changeCl(cl);
        }

        onWaitForIA:
        {
            setTimeout(game.nextStepIA,1000);
        }

    }
    Timer
    {
        id: timer
        running: false
        repeat: false

        property var callback

        onTriggered: {
        callback();
    }
    }
    function setTimeout(callback, delay)
    {
        if (timer.running)
        {
            console.error("nested calls to setTimeout are not supported!", JSON.stringify(callback),
            JSON.stringify(timer.callback));
            return;
        }
        timer.callback = callback;
        // note: an interval of 0 is directly triggered, so add a little padding	104
        timer.interval = delay + 1;
        timer.running = true;
    }

    function startGame()
    {
       setTimeout(game.start,100);
    }

    // PLAYER 0
    ListView{
        id:list0
        //STYLE
        width:parent.width-200
        height:150
        //interactive:false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5;
        anchors.left: parent.left
        anchors.leftMargin:200
        orientation:ListView.Horizontal
        //spacing: -50
        //clip:true;

        //DATA
        model:HandModel{
            list:hand_j0
        }
        delegate:Rectangle{
            width: (list0.width/list0.count>150*0.65)?150*0.65:list0.width/list0.count
            Carte{listdata:list0
            show:true}
        }

    }

    // PLAYER 1
    ListView{
        rotation: {originX:width/2;originY:height/2;angle:180}
        id:list2

        //STYLE
        width:parent.width/2
        height:150
        anchors.horizontalCenter: parent.horizontalCenter
        highlightRangeMode: ListView.StrictlyEnforceRange
        //interactive:false
        anchors.left: parent.left
        anchors.leftMargin:parent.width/4
        anchors.top: parent.top
        anchors.topMargin: -75
        orientation:ListView.Horizontal
        //spacing: -50
        //clip:true;

        interactive: false

        //DATA
        model:HandModel{
            list:hand_j2
        }
        delegate:Rectangle{
            width: list2.width/list2.count
            Carte{listdata:list2}
        }
    }

    ListView{
        rotation: {originX:width/2;originY:height/2;angle:180}
        id:list3

        //STYLE
        width:150*0.65
        height:parent.height/2
        //interactive:false
        anchors.left: parent.left
        anchors.leftMargin:-75*0.65
        anchors.top: parent.top
        anchors.topMargin: parent.height/4
        //spacing: -50
        //clip:true;

        interactive: false

        //DATA
        model:HandModel{
            list:hand_j3
        }
        delegate:Rectangle{
            height:list3.height/list3.count
            Carte{listdata:list3
                rotation: 90}
        }
    }

    ListView{
        rotation: {originX:width/2;originY:height/2;angle:180}
        id:list1

        //STYLE
        width:150*0.65
        height:parent.height/2
        //interactive:false
        anchors.right: parent.right
        anchors.rightMargin:-75*0.65
        anchors.top: parent.top
        anchors.topMargin: parent.height/4
        //spacing: -50
        //clip:true;

        interactive: false

        //DATA
        model:HandModel{
            list:hand_j1
        }
        delegate:Rectangle{
            height:list1.height/list1.count
            Carte{listdata:list1
                rotation: 90}
        }
    }

    // START GAME BUTTON

    // UNO !
    Button{
        id:unobtn

        height:gameForm.width/1280*100
        width:(gameForm.width/1280)*100
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: playCardBt.width+30

        background:Rectangle{
            anchors.fill:parent
            color:"#00000000"
            Image {
                id: name
                anchors.fill:parent
                source: "qrc:/resources/img/uno.png"
            }
        }

        onClicked:
        {
            game.unoBtPressed();
        }
    }


    Button{
        id:drawCardBt
        height:gameForm.width/1280*164
        width:gameForm.width/1280*108
        anchors.left: parent.left
        anchors.leftMargin:gameForm.width/1280*200
        anchors.top: parent.top
        anchors.topMargin: gameForm.width/1280*100
        rotation: -35

        background: Rectangle{
            color: "#00000000"
            Image{
                source:"qrc:/cartes/cartes/pioche.png"
                anchors.fill:parent
                fillMode: Image.Stretch
            }
        }
        onClicked: {
            if(myturn)
                game.drawCardBtPressed();
            myturn=false;
        }
    }
    Rectangle{
        id:playCardBt2
        height:gameForm.width/1280*150
        width:(gameForm.width/1280)*150*0.65
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color:"transparent"
        rotation: -5
        visible:false;

        function changecrd(cl, tp, vl,rt)
        {
            playCardBt2.visible=true;
            playCardBt2.rotation=rt;
            card3.changecrd(cl,tp,vl);
        }

        CarteBase{
            id: card3
            showCard: true
        }
    }
    // PLAY CARD & carte active
    Rectangle{
        id:playCardBt1
        height:gameForm.width/1280*150
        width:(gameForm.width/1280)*150*0.65
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color:"transparent"
        rotation: 10
        visible:false;

        function changecrd(cl, tp, vl,rt)
        {
            visible=true;
            playCardBt2.changecrd(card2.color,card2.type,card2.value,playCardBt1.rotation)
            playCardBt1.rotation=rt;
            card2.changecrd(cl,tp,vl);
        }

        CarteBase{
            id: card2
            showCard: true
        }
    }

    Rectangle{
        id:playCardBt
        height:gameForm.width/1280*150
        width:(gameForm.width/1280)*150*0.65
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color:"transparent"
        rotation: 0

        function changecrd(cl,tp,vl,rt)
        {
            playCardBt1.changecrd(card1.color,card1.type,card1.value,playCardBt.rotation)
            playCardBt.rotation=Math.floor(Math.random() * Math.floor(30))-15;
            card1.changecrd(cl,tp,vl);
        }

        CarteBase{
            id: card1
            color:"b"
            type:0
            value:0
            showCard: true
        }
    }

    Rectangle{
        id:changeColor
        height:gameForm.width/1280*300
        width:gameForm.width/1280*300
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color:"#00000000"

        visible: false

        Image {
            anchors.fill:parent
            source: "qrc:/cartes/cartes/color.png"
        }

        MouseArea{
            anchors.fill:parent
            onClicked: {
                console.log("change color ! x:" + mouse.x + " y:" +mouse.y);
                if(mouse.x<width/2)
                {
                    if(mouse.y<height/2)
                    {
                        game.playChangeColor(2);
                        card1.changeCl("b");
                        print("bleu");
                    }
                    else
                    {
                        game.playChangeColor(3);
                        card1.changeCl("j");
                        print("jaune");
                    }
                }
                else
                {
                    if(mouse.y<height/2)
                    {
                        game.playChangeColor(1);
                        card1.changeCl("v");
                        print("vert");
                    }
                    else
                    {
                        game.playChangeColor(0);
                        card1.changeCl("r");
                        print("rouge");
                    }
                }
                changeColor.visible=false;
            }
        }
    }

    Rectangle {
        id: rectangleEnd
        x: 351
        y: 242
        width: 609
        height: 288
        color: "#272727"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        visible: false

        property bool end: false

        Text {
            id: text1
            height: 100
            color: "#e98515"
            text: (rectangleEnd.end)?(qsTr("Victoire") + rootItem.emptyString):(qsTr("Défaite") + rootItem.emptyString)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40
            font.bold: true
            font.family: "Tahoma"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
        }

        Text {
            id: text2
            color: "#ffffff"
            text: qsTr("Voulez-vous refaire une partie ?") + rootItem.emptyString
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 20
            font.bold: true
            font.family: "Tahoma"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
        }
        Button {
            id: buttonYes
            text: qsTr("Oui") + rootItem.emptyString

            onHoveredChanged:
            {
                if(hovered)
                    playSnap.play();
            }

            background:Rectangle
                {
                    anchors.fill: parent
                    radius: 20
                    color:  buttonYes.hovered?"#e98515":"#ffffff"
                }
            onClicked:
            {
                playClick.play();
                startGame();
                rectangleEnd.visible=false;
            }
            font.pointSize: 15
            width: 150
            anchors.horizontalCenterOffset: -100
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Button {
            id: buttonNo
            text: qsTr("Non") + rootItem.emptyString

            onHoveredChanged:
            {
                if(hovered)
                    playSnap.play();
            }

            background:Rectangle
                {
                    anchors.fill: parent
                    radius: 20
                    color:  buttonNo.hovered?"#e98515":"#ffffff"
                }
            onClicked:
            {
                playClick.play();
                network.roomList();
                swipeVertical.currentIndex=1;
                swipeHorizontalServeur.currentIndex=1;
                changedReturnButton();
            }
            font.pointSize: 15
            width: 150
            anchors.horizontalCenterOffset: 100
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
