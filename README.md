# BmpEncoder
A module that can write raw bmp image files.
# Example
```lua
local Bitmap = {}

for y = 1, 255 do
    Bitmap[y] = {}
    for x = 1, 255 do
        Bitmap[y][x] = {x, y, math.sqrt(x * y)}
    end
end

writefile("example.bmp", ArrayToBmp(Bitmap))
```
# Output
![](https://raw.githubusercontent.com/0zBug/BmpEncoder/main/example.bmp)
