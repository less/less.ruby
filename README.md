LESS
====
It's time CSS was done right – LESS is _leaner_ css.

Explained
---------
LESS allows you to write CSS the way (I think) it was meant to, that is: with *variables*, *nested rules* and *mixins*!

### Here's some example LESS code:
	
	@dark: #110011;
	.outline { border: 1px solid black }
	
	.article {
		a { text-decoration: none }
		p { color: @dark }
		.outline;
	}
	
### And the CSS output it produces:
	
	.outline { border: 1px solid black }
	.article a { text-decoration: none }
	.article p { color: #110011 }
	.article { border: 1px solid black }
	
If you have CSS nightmares, just 
	$ lessc style.less

For more information, see you at [http://lesscss.org]

People without whom this wouldn't have happened a.k.a *Credits*
---------------------------------------------------------------

- **Dmitry Fadeyev**, for pushing me to do this, and designing our awesome website
- **August Lilleaas**, for initiating the work on the treetop grammar, as well as writing the rails plugin
- **Nathan Sobo**, for creating treetop
- **Jason Garber**, for his magical performance optimizations on treetop
- And finally, the people of #ruby-lang for answering all my ruby questions. **apeiros**, **manveru** and **rue** come to mind
