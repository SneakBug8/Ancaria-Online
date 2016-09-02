-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here
print ("Game started")
crypto = require("crypto")
require("noobhub")
local weapon={"Деревянный меч",1}
local armor={"Одежда",1}
local money="100"
local scene  = display.newGroup()
local playergroup = display.newGroup()
local controls = display.newGroup()
local inventory = display.newGroup()

local map = display.newImage (scene,"map1.png",  display.contentCenterX+16, display.contentCenterY+16)
-- local layer2 = display.newImage (map, "layer2.png")
local character = display.newImage (scene, "char.png" ,display.contentCenterX , display.contentCenterY)
local player = display.newImage (scene,"char.png",1000,1000)
local upbutton = display.newImage (controls,"up.png" , 165, 400)
local downbutton = display.newImage (controls,"down.png" , upbutton.x , upbutton.y+64)
local leftbutton = display.newImage (controls,"left.png" , upbutton.x-64 , upbutton.y+64)
local rightbutton = display.newImage (controls,"right.png" , upbutton.x+64 , upbutton.y+64)
local invbutton = display.newImage (controls,"inv.png" , rightbutton.x+64 , rightbutton.y-64)
local atkbutton = display.newImage (controls,"attack.png" , leftbutton.x-64 , rightbutton.y-64)

local playerobj={}
local playersid={}

local coords = display.newText(controls,"Hello World!", 100, 200, native.systemFont, 16 )
local menu = display.newImage (inventory,"menu.jpg" ,display.contentCenterX , display.contentCenterY)

local send = display.newImage (controls,"send.png" ,display.contentCenterX+135, 0)

local mycloud = display.newText("", character.x, character.y-25, native.systemFont, 16 )
local hiscloud = display.newText("", player.x, player.y-25, native.systemFont, 16 )
local chatinput = native.newTextField(display.contentCenterX, display.contentCenterY, 250, 25)
local passinput = native.newTextField(display.contentCenterX-25, 64, 250, 25)

chatinput.anchorX=0.5
chatinput.anchorY=0.5
chatinput.x = display.contentCenterX-25
chatinput.y=0
chatinput.height=25
local packet={}
local startbutton = display.newImage (inventory,"start.png" , chatinput.x , chatinput.y+128)

local nickname=""

function sendchat()
notify(chatinput.text)
packet[1]=nickname
packet[2]="chat"
packet[5]=chatinput.text
hub:publish({
		message = {
			action  =  packet,
			timestamp = system.getTimer()
		}
		})
chatinput.text=""
end
send:addEventListener( "tap", sendchat )

function reload ()
mycloud.x=character.x
mycloud.y=character.y-25
hiscloud.x=player.x
hiscloud.y=player.y-25
	-- None for now
	if character.x>map.x+1024 then
		map.x=map.x+32
		character.x=map.x+1024-16
		elseif character.y>map.y+1024 then
			map.y=map.y+32
			character.y=map.y+1024-16
elseif character.y<map.y-1024 then
			map.y=map.y-32
			character.y=map.y-1024+16
		elseif character.x<map.x-1024 then
		map.x=map.x-32
		character.x=map.x-1024+16	
		end
coord()
coords.text = map.x.." "..map.y
-- "X: "..coordx.." Y: "..coordy
local packet={}
packet[1]=nickname
packet[2]="move"
packet[3]=map.x-character.x
packet[4]=map.y-character.y
hub:publish({
		message = {
			action  =  packet,
			timestamp = system.getTimer()
		}
		})
checkloot()
end

function goup()
map.y=map.y+32
playergroup.y=playergroup.y+32
--[[map.y=map.y+32
	player.y=player.y+32]]--
	reload()
	napr = "up"
end
upbutton:addEventListener( "tap", goup )
function godown()
map.y=map.y-32
	playergroup.y=playergroup.y-32
	reload()
	napr = "down"
end
downbutton:addEventListener( "tap", godown )
function goleft()
map.x=map.x+32
	playergroup.x=playergroup.x+32
	reload()
	napr = "left"
end
leftbutton:addEventListener( "tap", goleft )
function goright()
map.x=map.x-32
	playergroup.x=playergroup.x-32
	reload()
	napr = "right"
end
rightbutton:addEventListener( "tap", goright )
function reader(message)
	print (message.action[1].."  "..message.action[2].."  "..message.action[3].." "..message.action[4])
if message.action[1]~=nickname then
if message.action[2]=="move" then
	for i=1,10 do
		if playersid[i]==message.action[1] then
print (message.action[3].." "..message.action[4])
-- local playerx=-(coordx-message.action[3])*32
-- local playery=-(coordy-message.action[4])*32
playerobj[i].x = map.x+(-message.action[3])
-- display.contentCenterX-playerx
playerobj[i].y = map.y+(-message.action[4])
-- display.contentCenterY-playery
break
end
end
elseif message.action[2]=="chat" then
hiscloud.text=message.action[5]
timer.performWithDelay( 1000, removecloud, 1 )
elseif message.action[2]=="login" then
	for i=1,10 do
		if playersid[i]==nil then
		coord()
playersid[i]=message.action[1]
playerobj[i]=display.newImage (playergroup,"char.png",1000,1000)
playerobj[i].x = map.x+(-message.action[3])
-- display.contentCenterX-playerx
playerobj[i].y = map.y+(-message.action[4])
--[[playerobj[i].x = (map.x-1024)+(message.action[3]*32)
playerobj[i].y = (map.y-1024)+(coordy-message.action[4]*32)
print ("Вошел игрок с id "..playersid[i])]]--
login()
break
		end
	end
end
end
end
function coord()
_G.coordx=-(((map.x-1024)-character.x+16)/32)+1
-- (((map.x-1024-176+32)/32)-1)
-- -(((map.x - character.x)/32)-0.5+32)
-- -(((map.x-1024-176+32)/32)-1)
_G.coordy=-(((map.y-1024)-character.y+16)/32)+1
-- (((map.y-1024-256+48)/32)-1.5)
-- ((map.y - character.y)/32)-0.5
-- -(((map.y-1024-256+32)/32)-1)
end
function start ()
nickname = chatinput.text
passfile= "https://raw.githubusercontent.com/SneakBug8/Ancaria-Online/master/characters/"..nickname.."/password.txt"
network.request(passfile, "GET", passlistener )
	if passinput.text == password then
chatinput.text=""
hub = noobhub.new({ server = "46.4.76.236"; port = 1337; });
hub:subscribe({
	channel = "ancaria";
	callback = reader
	});
login()
	reload()
menu:removeSelf()
startbutton:removeSelf()
-- load
function loaddata()
	passinput:removeSelf()
if nickname=="" then
charstatus="Житель"
else
charfile= "https://raw.githubusercontent.com/SneakBug8/Ancaria-Online/master/characters/"..nickname.."/status.txt"
armor1file = "https://raw.githubusercontent.com/SneakBug8/Ancaria-Online/master/characters/"..nickname.."/armor1.txt"
armor2file = "https://raw.githubusercontent.com/SneakBug8/Ancaria-Online/master/characters/"..nickname.."/armor2.txt"
weapon1file = "https://raw.githubusercontent.com/SneakBug8/Ancaria-Online/master/characters/"..nickname.."/weapon1.txt"
weapon2file = "https://raw.githubusercontent.com/SneakBug8/Ancaria-Online/master/characters/"..nickname.."/weapon2.txt"
moneyfile = "https://raw.githubusercontent.com/SneakBug8/Ancaria-Online/master/characters/"..nickname.."/money.txt"
network.request(charfile, "GET", statuslistener )
network.request(armor1file, "GET", armor1listener )
network.request(armor2file, "GET", armor2listener )
network.request(weapon1file, "GET", weapon1listener )
network.request(weapon2file, "GET", weapon2listener )
network.request(moneyfile, "GET", moneylistener )
end
end
loaddata()
end
	end
	startbutton:addEventListener( "tap",start )
 function login ()
 	-- body
 print ("Login")
coord()
 	local packet={}
packet[1]=nickname
packet[2]="login"
packet[3]=coordx
packet[4]=coordy
hub:publish({
		message = {
			action  =  packet,
			timestamp = system.getTimer()
		}
		})
 end
	function removecloud()
		-- body
		mycloud.text=nickname
		hiscloud.text=hisnick
	end

function showinventory()
	inventory.x=0
invbackground = display.newImage (inventory,"invbackground.png" ,display.contentCenterX , display.contentCenterY)
local status = display.newText(inventory,"Статус: "..charstatus,display.contentCenterX, display.contentCenterY-80-64, native.systemFont, 24)
local stats = display.newText(inventory,"ATK: "..weapon[2].." DEF: "..armor[2],display.contentCenterX, display.contentCenterY-80, native.systemFont, 24)
local weapontext = display.newText(inventory,"Оружие: "..weapon[1].." ATK:"..weapon[2], display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
local armortext = display.newText(inventory,"Броня: "..armor[1].." DEF: "..armor[2], display.contentCenterX , display.contentCenterY+64, native.systemFont, 16 )
local moneytext = display.newText(inventory,"Золото: "..money, display.contentCenterX , display.contentCenterY+128, native.systemFont, 16 )

local closeinv = display.newImage (inventory,"closeinv.png" , display.contentWidth-32, 15)

function hideinventory()
	-- body
inventory.x=1000
end
closeinv:addEventListener( "tap", hideinventory )
end
invbutton:addEventListener( "tap", showinventory )
function checkloot()
	-- body
	if coordx==15 and coordy==15 then
		addarmor("Доспех",2)
	end
end

function addarmor(name, def)
	-- body
armor[1]=name
armor[2]=def
notify("Подобрано: "..armor[1].." DEF: "..armor[2])
end

function addweapon(name, atk)
	-- body
	weapon[1]=name
	weapon[2]=atk
end

function addmoney(count)
	-- body
	money=money+count
end

function notify (text)
	mycloud.text=text
	timer.performWithDelay( 2000, removecloud, 1 )
end

function attack()
	-- body
attackanim=nil
if napr == "up" then
_G.attackanim = display.newImage (controls,"attackanim.png" ,character.x,character.y-32)
elseif napr == "down" then
_G.attackanim = display.newImage (controls,"attackanim.png" ,character.x,character.y+32)
elseif napr=="left" then
_G.attackanim = display.newImage (controls,"attackanim.png" ,character.x-32,character.y)
elseif napr=="right" then
_G.attackanim = display.newImage (controls,"attackanim.png" ,character.x+32,character.y)
end
timer.performWithDelay( 1000,destroysword, 1 )
end
atkbutton:addEventListener( "tap", attack )

function destroysword()
	attackanim:removeSelf()
end

function statuslistener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
        charstatus="Житель"
    else
        print ( "RESPONSE: " .. event.response )
        charstatus=event.response
        if string.match (charstatus,"404")==nil then
            else
        charstatus="Житель"
    end
    end
end
function armor1listener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
        charstatus="Житель"
    else
armor[1]=event.response
    end
end
function armor2listener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
        charstatus="Житель"
    else
        armor[2]=event.response
    end
end
function weapon1listener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
        charstatus="Житель"
    else
       weapon[1]=event.response
    end
end

function weapon2listener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
        charstatus="Житель"
    else
        weapon[2]=event.response
    end
end

function moneylistener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
        charstatus="Житель"
    else
       money=event.response
    end
end

function passlistener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
        charstatus="Житель"
    else
       password = event.response
    end
end