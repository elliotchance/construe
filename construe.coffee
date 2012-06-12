fs = require('fs')

class Construe

	constructor: () ->
		@columnWidth = 60
		@prefix = "#~ "
		@condense = true

	usage: () ->
		console.error("Usage: coffee construe <main file> <derived file>")
		
	setMainFile: (@mainFile) ->
		# nothing
		
	setDerivedFile: (@derivedFile) ->
		# nothing
		
	fixedPad: (string, length, ch = ' ') ->
		# truncate
		if string.length > length
			return string.substr(0, length - 3) + "..."
		
		# pad
		string += ch until string.length == length
		return string
		
	condenseBlock: (block) ->
		lines = block.split(/\n/g)
		
		# extract the left lines
		left = []
		for key, line of lines
			break if line.substr(0, 1) == ' '
			left.push(line.substr(0, @columnWidth))
		
		# extract the right lines
		right = []
		for key, line of lines
			right.push(line.substr(@columnWidth + 5)) if line.length > @columnWidth + 5
			
		# reconstruct
		out = ''
		i = 0
		loop
			break if not left[i] and not right[i]
			if left[i]
				out += left[i]
			else
				out += @fixedPad("", @columnWidth, ' ')
			out += "  |  "
			out += right[i] if right[i]
			out += "\n"
			++i
	
		return out.trim()
	
	run: () ->
		mainFileLines = (fs.readFileSync(@mainFile, 'utf8').trim() + "\n").split("\n")
		derivedFileLines = (fs.readFileSync(@derivedFile, 'utf8').trim() + "\n").split("\n")
		
		mainFileLineNumber = 0
		derivedFileLineNumber = 0
		
		# read lines
		block = ''
		loop
			stop = false
			lastLine = null
			
			loop
				derivedLine = derivedFileLines[derivedFileLineNumber++]
				lastLine = derivedLine
				break if derivedFileLineNumber > derivedFileLines.length - 1
				break if derivedLine.substr(0, @prefix.length) == @prefix
				if derivedLine?.trim() != ''
					block += @fixedPad("", @columnWidth) + "  |  " +
						@fixedPad("" + derivedFileLineNumber + ". " + derivedLine?.trim(), @columnWidth) + "\n"
			
			if block.substr(block.length - 2, 2) != '|\n'
				if @condense
					console.log(@condenseBlock(block))
				else
					console.log(block)
				console.log(@fixedPad("", @columnWidth + 2, '_') + "|" + @fixedPad("", @columnWidth + 2, '_') + "\n" + @fixedPad("", @columnWidth + 2, ' ') + "|")
				block = ""

			# skip blank lines in main
			loop
				break if mainFileLines[mainFileLineNumber++]?.trim() != ''
			--mainFileLineNumber
			
			mainLine = mainFileLines[mainFileLineNumber++]
			
			# recognise the end of the file
			if mainFileLineNumber > mainFileLines.length
				break
			
			if mainLine?.trim() != lastLine.substr(@prefix.length)?.trim()
				block += @fixedPad("" + (mainFileLineNumber + 1) + ". " + mainLine, @columnWidth) +
					"  >  " + @fixedPad("<NOT FOUND>", @columnWidth) + "\n"
				break
			
			break if mainFileLineNumber > mainFileLines.length - 1
			if mainLine?.trim() != ''
				block += @fixedPad("" + (mainFileLineNumber + 1) + ". " + mainLine, @columnWidth) +
					"  |\n"
		
		# the left over lines in the derived file
		loop
			derivedLine = derivedFileLines[derivedFileLineNumber++]
			break if derivedFileLineNumber > derivedFileLines.length
			if derivedLine?.trim() != ''
				block += @fixedPad("", @columnWidth) + "  |  " +
					@fixedPad("" + derivedFileLineNumber + ". " + derivedLine?.trim(), @columnWidth) + "\n"
		
		if @condense
			console.log(@condenseBlock(block))
		else
			console.log(block)

construe = new Construe()

if process.argv.length < 4
	construe.usage()
	process.exit(1)

construe.setMainFile(process.argv[2])
construe.setDerivedFile(process.argv[3])
construe.run()
