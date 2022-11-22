return {
	{'.transition', 'transition-property: background-color, border-color, color, fill, stroke, opacity, box-shadow, transform, filter, -webkit-backdrop-filter;|transition-property: background-color, border-color, color, fill, stroke, opacity, box-shadow, transform, filter, backdrop-filter;|transition-property: background-color, border-color, color, fill, stroke, opacity, box-shadow, transform, filter, backdrop-filter, -webkit-backdrop-filter;|transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);|transition-duration: 150ms;', base=true},
	{'.transition-none', 'transition-property: none;', base=true},
	{'.transition-all', 'transition-property: all;|transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);|transition-duration: 150ms;', base=true},
	{'.transition-colors', 'transition-property: background-color, border-color, color, fill, stroke;|transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);|transition-duration: 150ms;', base=true},
	{'.transition-opacity', 'transition-property: opacity;|transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);|transition-duration: 150ms;', base=true},
	{'.transition-shadow', 'transition-property: box-shadow;|transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);|transition-duration: 150ms;', base=true},
	{'.transition-transform', 'transition-property: transform;|transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);|transition-duration: 150ms;', base=true},
}