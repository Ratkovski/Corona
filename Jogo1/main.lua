local fisica =require ("physics")
fisica.start()
 

  display.setStatusBar(display.HiddenStatusBar)
 w=display.contentWidth
 h=display.contentHeight

 --local soundTrack = audio.loadStream("sounds/_Party_Rock_Anthem_(Disco_Reason_Remix)_[Mp3ty.lt].mp3")
--audio.play( soundTrack, { channel = 2, loops=-1, fadein=1000 }  )

 moverx=0--variavel utilizada para mover o personagen a longo do eixo x
 pulando=true--serve para ver se esta tocando no chao
 score=0--definir  placar
 --vida=20--definir  placar 
 som=audio.loadSound("sounds/coin.wav")
 som2=audio.loadSound("sounds/Fatality.mp3")
 velocidade=5
 --add fundo
 local fundo = display.newImage("images/fd2.gif")
fundo.x = w/2
fundo.y = h/2

local grama_inferior= display.newImage("images/grass_top.png")
grama_inferior.x=w/2
grama_inferior.y=h-20
fisica.addBody(grama_inferior,"static",{friction=0.5,bounce=0.3})
grama_inferior.myName="grass"

--local grama_superior =display.newImage("images/grass_top.png")
--grama_superior.x=w/2
--grama_superior.y=h+95---95
--fisica.addBody(grama_superior,"static",{friction=0.5,bounce=0.3})
--grama_inferior.myName="grass"

--add jogador1
local jogador1 =display.newImage("images/j1.png")
fisica.addBody(jogador1,"dinamic",{friction=0.5 ,bounce=0})
jogador1.x=math.random(100,w-100)
jogador1.y= 160
jogador1.myName="jogador1"
jogador1.isFixedRotation = true

--add parede esquerda
local parede_esquerda =display.newRect(-1,h/2,0,h)
fisica.addBody(parede_esquerda,"static")
--add parede direita
local parede_direita =display.newRect(w+3,h/2,0,h)
fisica.addBody(parede_direita,"static")
--add seta esquerda
local seta_esquerda =display.newImage("images/btn_arrow.png")
seta_esquerda.x=45
seta_esquerda.y=280
seta_esquerda.rotation = 180

--add seta direita
local seta_direita =display.newImage("images/btn_arrow.png")
seta_direita.x=120
seta_direita.y=283
--seta_direita.rotation = 180

--add saltaer
local seta_saltar =display.newImage("images/btn_arrow.png")
seta_saltar.x=440
seta_saltar.y=280
seta_saltar.rotation = 270

--add placar

local placar = display.newText("Placar: "..score,5,0,native.systemFont,16)
placar.x =50
placar.y = 30
placar:setTextColor (255,255,255)



--local vida= display.newText("Vida: "..vida,10,0,native.systemFont,16)
--vida.x =150
--vida.y = 30
--vida:setTextColor (255,255,255)
--funcao para mover o personagem
local function moverjogador1(event )
	jogador1.x=jogador1.x+moverx

end 
Runtime:addEventListener("enterFrame",moverjogador1)

--funcao parar o movimento
local function stop( event )
	if event.phase =="ended" then
	moverx = 0
	end
end 
Runtime:addEventListener("touch",stop)

--mover para a esquerda
function seta_esquerda:touch()
moverx= -velocidade
jogador1.xScale=-1
end
seta_esquerda:addEventListener("touch",seta_esquerda)

--mover para a direita
function seta_direita:touch()
moverx= velocidade
jogador1.xScale=1
end
seta_direita:addEventListener("touch",seta_direita)

--faz o personagen saltaer
function seta_saltar:touch(event)
if(event.phase =="began"and pulando ==false) then
	pulando=true
	jogador1:setLinearVelocity(0, -200)
end
end
seta_saltar:addEventListener("touch",seta_saltar)

function Colisao(event )
if(event.object1.myName=="grass"and event.object2.myName=="jogador1")then
	pulando=false
end
if(event.object1.myName=="grass"and event.object2.myName=="alvo")then
	event.object2:removeSelf()
end
if(event.object1.myName=="grass"and event.object2.myName=="morte")then
	event.object2:removeSelf()
end
if(event.object1.myName=="jogador1"and event.object2.myName=="alvo")then
	score = score+1
	placar.text = "Placar:"..score

	audio.play(som)
	event.object2:removeSelf()
end
if(event.object1.myName=="jogador1"and event.object2.myName=="morte")then

	local alvo=display.newImage("images/game over.png")
	alvo.x=w/2
alvo.y=h-190
fisica.addBody(alvo,"static",{friction=0.5,bounce=0.3})
alvo.myName="alvo"
	audio.play(som2)
	event.object2:removeSelf()
		
	
end


end
Runtime:addEventListener("collision",Colisao)
function criaralvos()
	alvo=display.newImage("images/beeper.png")
	alvo.x=math.random(5, w-5)
	alvo.y=0
	fisica.addBody(alvo,"dinamic")
	alvo.myName="alvo"
end
timer.performWithDelay(500,criaralvos,0)
function criarMorte()
m=display.newImage("images/alvo.png")
	m.x=math.random(5, w-5)
	m.y=0
	fisica.addBody(m,"dinamic")
	m.myName="morte"
end
timer.performWithDelay(2300,criarMorte,0)