local theme = {
	fill = 'TabLineFill',
	-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
	head = 'TabLine',
	-- current_tab = 'TabLineSel',
	current_tab = { fg = '#F8FBF6', bg = '#5170ff', style = 'bold' },
	tab = 'TabLine',
	win = 'TabLine',
	tail = 'TabLine',
}

require('tabby.tabline').set(function(line)
	return {
		{
			{ '  ', hl = theme.head },
			line.sep('', theme.head, theme.fill),
		},
		line.tabs().foreach(function(tab)
			local hl = tab.is_current() and theme.current_tab or theme.tab
			return {
				line.sep('', hl, theme.fill),
				'[',
				tab.number(),
				']',
				tab.name(),
				line.sep('', hl, theme.fill),
				hl = hl,
				margin = ' ',
			}
		end),
		line.spacer(),

		{
			line.sep('', theme.tail, theme.fill),
			{ '  ', hl = theme.tail },
		},
		hl = theme.fill,
	}
end)
