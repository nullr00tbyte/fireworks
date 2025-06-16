require("firework")
require("explosion")

cohetes = {}
explosiones = {}

function love.load()
shader = love.graphics.newShader("assets/CRT.fs")
shader2 = love.graphics.newShader("assets/flame.fs")
shader:send("time", 0)
shader:send("distortion_fac", {1.01, 1.02})  -- Valores bajos para evitar distorsión excesiva
shader:send("scale_fac", {1.0, 1.0})
shader:send("feather_fac", 0.1)  -- Reduce para que no oscurezca los bordes
shader:send("noise_fac", 0.02)   -- Ruido bajo
shader:send("bloom_fac", 0.000001)    -- Efecto de brillo suave
shader:send("crt_intensity", 0.2) -- Intensidad moderada del efecto CRT
shader:send("glitch_intensity", 0.5) -- Desactiva el glitch para el fondo
shader:send("scanlines", 1000.0)  -- Densidad de líneas de escaneo

shader2:send("time", 0)
shader2:send("amount", 1.0)

shader2:send("colour_1", {1.0, 0.5, 0.0, 1.0}) -- naranja fuego
shader2:send("colour_2", {0.2, 0.2, 0.2, 1.0}) 
  love.window.setMode(0, 0, {vsync = true})
  love.window.setTitle("Firework")
  background = love.graphics.newImage("assets/city.png")

end

function love.update(dt)
    shader:send("time", love.timer.getTime())  
    shader2:send("time", love.timer.getTime())  
    for _, cohete in ipairs(cohetes) do
        print("velocidad X: "   .. cohete.vx ..
              " Velocidad Y: " .. cohete.vy ..
              " Gas: " .. cohete.gas ..
              " Aceleracion: " .. cohete.aceleracion ..
              " Angulo: " .. cohete.angulo)
        cohete:update(dt)
        if cohete.played_sound == false then
            if cohete.gas > 0 then
                sound = love.audio.newSource("assets/takeoff.ogg", "stream")
                cohete.played_sound = true
                love.audio.play(sound)
            end
        end
        if cohete.gas <= 0 or cohete.velocidad <= 0 then
            table.insert(explosiones, Explosion:new(cohete.x, cohete.y, 1000))
            sound = love.audio.newSource("assets/explosion.ogg", "stream")
            love.audio.play(sound)
            table.remove(cohetes, _)
        end
        
    end

    for i = #explosiones, 1, -1 do
        explosiones[i]:update(dt)
        if explosiones[i]:isDead() then
            table.remove(explosiones, i)
        end
    end
end



function love.mousepressed( x, y, button, istouch, presses )
  if button == 1 then
    local cohete = Cohete:new(x, y, 3, 10,500, math.random(75,105), 2, math.random(3,5)) -- (x, y, w, h, aceleracion, angulo, velocidad, gas)
    table.insert(cohetes, cohete)
  end
end

function love.draw()
    love.graphics.setShader(shader)
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
    love.graphics.setShader()
    for _, cohete in ipairs(cohetes) do
        shader2:send("texture_details", {0.0, 0.0, cohete.w, cohete.h})
        shader2:send("image_details", {cohete.w, cohete.h})
       love.graphics.setShader(shader2)
        cohete:draw()
        love.graphics.setShader()
    end

    for _, exp in ipairs(explosiones) do
        exp:draw()
    end
   
end