local TextParticle = {}

function TextParticle.Create(pos, text)
    local e = {
        pos = pos,
        text = text,
        age = 0,
        lifetime = 200
    }
    u.addId(e)
    table.insert(text_particles, e)
    return e
end

function TextParticle.Update(e)
    e.pos = Pos.add(e.pos, Pos.new(0, -0.5))
    e.age = e.age + 1

    if e.age > e.lifetime then
        table.remove(text_particles, u.indexWithId(text_particles, e.id))
    end
end

function TextParticle.Draw(e)
    love.graphics.print(e.text, math.floor(e.pos.x), math.floor(e.pos.y))
end

return TextParticle
