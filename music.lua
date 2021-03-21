return function()
  local music = {
    queue = {},
    currentsong = 1,
  }

  local function shuffle(list)
    for i = #list, 2, -1 do
      local j = math.random(i)
      list[i], list[j] = list[j], list[i]
    end
  end

  local files = {
    "Abandoned One.ogg",
    "Abandoned Site.ogg",
    "Altus Stratum.ogg",
    "Ancient Light.ogg",
    "Another World.ogg",
    "Crystal Cave.ogg",
    "Crystalites.ogg",
    "Crystalites v2.ogg",
    "Deception Dungeon.ogg",
    "Ethereal Being.ogg",
    "Flare it Up.ogg",
    "Fresh Binding.ogg",
    "Lava Temple.ogg",
    "Look Around You.ogg",
    "Sewer.ogg",
    "Space Constellation.ogg",
    "Spooky.ogg",
    "The Dark One.ogg",
    "The World Upon You.ogg",
    "Witch's Tower.ogg",
  }

  for i, file in ipairs(files) do
    local src = love.audio.newSource("assets/music/" .. file, "stream")
    table.insert(music.queue, src)
  end

  shuffle(music.queue)
  music.queue[1]:play()

  function music:update(dt)
    if not self.queue[self.currentsong]:isPlaying() then
      self.currentsong = self.currentsong + 1
      if self.currentsong > #self.queue then
        shuffle(self.queue)
        self.currentsong = 1
      end
      self.queue[self.currentsong]:play()
    end
  end

  return music
end
