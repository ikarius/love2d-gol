require "main"

describe("Coordinates to index and vice-versa", function()
    it("Must convert an index to cartesian coords (1-indexed)", function()
        local x,y
        x,y = indexToCoords(1)
        assert.equals(x, 1, y, 1)
        x,y = indexToCoords(50)
        assert.equals(x, 50, y, 1)
        x,y = indexToCoords(51)
        assert.equals(x, 1, y, 2)
        x,y = indexToCoords(2499)
        assert.equals(x, 49, y, 50)
        x,y = indexToCoords(2500)
        assert.equals(x, 50, y, 50)


    end)
end)