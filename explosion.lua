Explosion = {}
Explosion.__index = Explosion

function Explosion:new(x, y, cantidad)
    local self = setmetatable({}, Explosion)
    self.particulas = {}
    for i = 1, cantidad do
        local angulo = math.random() * 2 * math.pi
        local velocidad = math.random(50, 150)
        local vx = math.cos(angulo) * velocidad
        local vy = math.sin(angulo) * velocidad
        table.insert(self.particulas, {
            x = x,
            y = y,
            vx = vx,
            vy = vy,
            life = math.random(0.5, 1),
            size = math.random(1, 2),
            color = {
                math.random(1, 255),
                math.random(1, 255),
                math.random(1, 255),
                1
            }
        })
    end
    return self
end

function Explosion:update(dt)
    for i = #self.particulas, 1, -1 do
        local p = self.particulas[i]
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(self.particulas, i)
        else
            p.vy = p.vy + 200 * dt -- gravedad
            p.x = p.x + p.vx * dt
            p.y = p.y + p.vy * dt
        end
    end
end

function Explosion:draw()
    for _, p in ipairs(self.particulas) do
        love.graphics.setColor(p.color[1]/255, p.color[2]/255, p.color[3]/255, p.life)
        love.graphics.circle("fill", p.x, p.y, p.size)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Explosion:isDead()
    return #self.particulas == 0
end
