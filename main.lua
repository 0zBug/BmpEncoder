
return function(Bitmap)
	local SizeY, SizeX = #Bitmap, #Bitmap[1]

	local ImageData = {
		#Bitmap, 4, #Bitmap[1], 4,
		1, 2, 32, 2, 3, 4, 32, 4,
		2835, 4, 2835, 4, 0, 4, 0, 4
	}

	local ColorSpace = {
		0, 0, 255, 0,
		0, 255, 0, 0,
		255, 0, 0, 0,
		0, 0, 0, 255,
		32, 110, 105, 87
	}

	local Gamma = {
		0, 36, 0, 4,
		0, 4, 0, 4
	}

	local Data = ""
	for Byte = 1, #ImageData, 2 do
		ImageData[Byte + 1] = ImageData[Byte + 1] or 1
		
		local Bytes = ""
		for Index = 1, ImageData[Byte + 1] do 
			Bytes = string.char(tonumber(string.sub(string.format("%0" .. (ImageData[Byte + 1] * 2) .. "X", ImageData[Byte]), (Index - 1) * 2 + 1, (Index - 1) * 2 + 2), 16)) .. Bytes
		end

		Data = Data .. Bytes
	end

	for Space = 1, #ColorSpace, 4 do
		local Bytes = ""

		for Index = 1, 4 do 
			Bytes = Bytes .. string.char(ColorSpace[(Space - 1) + Index])
		end
		
		Data = Data .. Bytes
	end

	for Byte = 1, #Gamma, 2 do
		Gamma[Byte + 1] = Gamma[Byte + 1] or 1
		
		local Bytes = ""
		for Index = 1, Gamma[Byte + 1] do 
			Bytes = string.char(tonumber(string.sub(string.format("%0" .. (Gamma[Byte + 1] * 2) .. "X", Gamma[Byte]), (Index - 1) * 2 + 1, (Index - 1) * 2 + 2), 16)) .. Bytes
		end

		Data = Data .. Bytes
	end

	local Bytes = ""

	for Index = 1, 4 do
		Bytes = string.char(tonumber(string.sub(string.format("%08X", #Data + 4), (Index - 1) * 2 + 1, (Index - 1) * 2 + 2), 16)) .. Bytes
	end
	
	Data = Bytes .. Data

	local CData = {}
	for y = SizeY, 1, -1 do
		for x = 1, SizeX do
			table.insert(CData, string.char(math.min(math.max(Bitmap[y][x][3] or 0, 0), 255)))
			table.insert(CData, string.char(math.min(math.max(Bitmap[y][x][2] or 0, 0), 255)))
			table.insert(CData, string.char(math.min(math.max(Bitmap[y][x][1] or 0, 0), 255)))
			table.insert(CData, string.char(math.min(math.max(Bitmap[y][x][4] or 255, 0), 255)))
		end
	end

	local Header = "BM"

	local HeaderData = {
		#Data + #CData + 14, 4,
		0, 2, 0, 2,
	}

	for Byte = 1, #HeaderData, 2 do
		HeaderData[Byte + 1] = HeaderData[Byte + 1] or 1
		
		local Bytes = ""
		for Index = 1, HeaderData[Byte + 1] do 
			Bytes = string.char(tonumber(string.sub(string.format("%0" .. (HeaderData[Byte + 1] * 2) .. "X", HeaderData[Byte]), (Index - 1) * 2 + 1, (Index - 1) * 2 + 2), 16)) .. Bytes
		end

		Header = Header .. Bytes
	end

	local Bytes = ""
	for Index = 1, 4 do
		Bytes = string.char(tonumber(string.sub(string.format("%08X", #Header + #Data + 4), (Index - 1) * 2 + 1, (Index - 1) * 2 + 2), 16)) .. Bytes
	end

	Header = Header .. Bytes

	return Header .. Data .. table.concat(CData)
end
