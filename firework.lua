Cohete = {}

Cohete.__index = Cohete
gravedad = 9.81

function Cohete:new(x, y, w, h, aceleracion, angulo, velocidad, gas)
    local cohete = setmetatable({}, Cohete)
    cohete.x = x
    cohete.y = y
    cohete.w = w
    cohete.h = h
    cohete.aceleracion = aceleracion
    cohete.angulo = angulo
    cohete.velocidad = velocidad
    cohete.gas = gas or 0.1
    cohete.rad = math.rad(angulo)
    cohete.vx = velocidad * math.cos(cohete.rad)
    cohete.vy = velocidad * math.sin(cohete.rad)
    cohete.played_sound = false

    -- Crear textura para partículas
    local imgData = love.image.newImageData(1, 1)
    imgData:setPixel(0, 0, 1, 1, 1, 1) -- blanco opaco
    local image = love.graphics.newImage(imgData)

    -- Crear sistema de partículas
    cohete.particleSystem = love.graphics.newParticleSystem(image, 500)
    cohete.particleSystem:setParticleLifetime(0.2, 0.5)
    cohete.particleSystem:setEmissionRate(80)
    cohete.particleSystem:setSizeVariation(1)
    cohete.particleSystem:setLinearAcceleration(-20, 20, 30, 120)
    cohete.particleSystem:setSizes(10)
    cohete.particleSystem:setColors(
        1, 1, 0, 1,    -- amarillo
        1, 0.5, 0, 0.8,-- naranja
        1, 0, 0, 0     -- rojo transparente
    )
    return cohete
end

function Cohete:update(dt)
    local rad = math.rad(self.angulo)

    -- Aceleraciones en x e y
    local ax = self.aceleracion * math.cos(rad)
    local ay = self.aceleracion * math.sin(rad) - gravedad

    -- Actualizar velocidades
    self.vx = self.vx + ax * dt
    self.vy = self.vy + ay * dt

    -- Actualizar posiciones
    self.x = self.x + self.vx * dt
    self.y = self.y - self.vy * dt

    -- 🌊 Efecto de serpenteo en X
    local a = 25 -- Amplitud del serpenteo
    local b = -0.1 -- Frecuencia del serpenteo
    local serpenteo = a * math.cos(b * love.timer.getTime()+0.1 * math.cos(love.timer.getTime()+30)*25)+0
    self.x = self.x + serpenteo * dt

    -- Consumir gas
    self.gas = self.gas - dt

    -- Disminuir aceleración
    if self.gas > 0 then
        self.aceleracion = self.aceleracion * 0.98
    else
        self.aceleracion = 0
    end

    -- Actualizar partículas
    if self.gas > 0 then
        self.particleSystem:start()
        self.particleSystem:setPosition(self.x + self.w / 2, self.y + self.h)
    end

    self.particleSystem:update(dt)
end

function Cohete:draw()
 
    -- Dibujar partículas
    love.graphics.draw(self.particleSystem)

    -- Dibujar cohete
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)

end
