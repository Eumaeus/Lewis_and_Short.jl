alphaMenu = begin 
	dcc_radioitems( 
		id = "alphaList", 
		className = "greekFont",
    labelStyle = Dict("display" => "flex"),
		options = [		
			(label = "Aa", value = "a"),
			(label = "Bb", value = "b"),
			(label = "Cc", value = "c"),
			(label = "Dd", value = "d"),
			(label = "Ee", value = "e"),
			(label = "Ff", value = "f"),
			(label = "Gg", value = "g"),
			(label = "Hh", value = "h"),
			(label = "Ii", value = "i"),
			(label = "Jj", value = "j"),
			(label = "Kk", value = "k"),
			(label = "Ll", value = "l"),
			(label = "Mm", value = "m"),
			(label = "Nn", value = "n"),
			(label = "Oo", value = "o"),
			(label = "Pp", value = "p"),
			(label = "Qq", value = "q"),
			(label = "Rr", value = "r"),
			(label = "Ss", value = "s"),
			(label = "Tt", value = "t"),
			(label = "Uu", value = "u"),
			(label = "Vv", value = "v"),
			(label = "Ww", value = "w"),
			(label = "Xx", value = "x"),
			(label = "Yy", value = "y"),
			(label = "Zz", value = "z")
		])
end

volumeList = begin
	dcc_radioitems(
		id = "volumeList",
		className = "greekFont",
    labelStyle = Dict("display" => "flex"), # or inline-block?
		options = []
	)
end

selectedUrnDiv = html_div( id = "selectedUrnDiv") do 
	html_p( id = "selectedUrnP", className = "app_hidden", "Urn goes here")
end

searchDiv = html_div( id = "searchDiv" ) do 
	html_label( className="inputLabel", htmlFor="greekInput", "Search Latin Entries:"),
	dcc_input( className="inputLabel", id="greekInput", debounce = false, autoComplete="off", type="text", size="18", value=""),
	html_span( id="greekOutput", "Nothing typed")
end

searchEnglishDiv = html_div( id = "searchEnglishDiv") do 
	html_label( className="inputLabel", htmlFor="englishInput", "Search All Text:"),
	dcc_input( className="inputLabel", id="englishInput", autoComplete="off", type="text", size="18", value=""),
	html_button( id="searchButton", "Search All Text", disabled = true)
end

passageInputDiv = html_div( id = "passageInputDiv" ) do 
	html_label( className="invalidPassage inputLabel", htmlFor="passageInput", "Retrieve by URN:"),
	dcc_input( className="inputLabel", id="passageInput", autoComplete="off", type="text", size="30", placeholder = "urn:cite2:hmt:ls.markdown:n21247"),
	html_button( id="querySubmit", disabled=true, value = "",  "Enter a valid URN")
end

resultsList = dcc_radioitems(
		id = "resultsList",
		className = "greekFont",
    labelStyle = Dict("display" => "inline-block"), # or inline-block?
		options = []
	)

entryDiv = html_div(id = "entryDiv", className = "greekFont") do
	html_div(id = "lexEntryDiv", className = "greekFont") do
		html_p( id = "lexEntryLinkP", className = "lexEntryLinkP") do 
			html_span( id = "lexEntryLink", className = "lexEntryLink", "")
		end,
		html_p( id = "lexEntryUrnP", className = "lexEntryUrnP") do 
			html_span( id = "lexEntryUrn", className = "lexEntryUrn", ""),
			dcc_clipboard( id = "copyUrn", className = "app_hidden", target_id = "lexEntryUrn")
		end,
		html_p( id = "lexEntryLabel", className = "lexEntryLabel", ""),
		html_div( id = "lexEntry", className = "lexEntry")
	end
end

#=
<div id="entryDiv" class="greekFont">
			<div id="lexEntryContainerDiv_urn:cite2:hmt:lsj.chicago_md:n8870" class="lexEntryDiv">
						<p class="lexEntryLinkP"><span class="lexEntryLink" id="entryLink_urn:cite2:hmt:lsj.chicago_md:n8870">
			<a href="http://folio2.furman.edu/lsj/?urn=urn:cite2:hmt:lsj.chicago_md:n8870">Link</a>
		</span>
						</p>
						<p class="lexEntryUrnP"><span class="lexEntryUrn" id="entryUrn_urn:cite2:hmt:lsj.chicago_md:n8870">
			<a> urn:cite2:hmt:lsj.chicago_md:n8870 </a></span></p>
						<p class="lexEntryLabel">ἀνθρωπο-βορία</p>
						<p class="lexEntry" id="lexEntry_urn:cite2:hmt:lsj.chicago_md:n8870"><strong>ἀνθρωποβορία</strong>, ἡ, <code>A</code> <strong>cannibalism</strong>, Zeno Stoic. 1.59 (pl.). 
</p>
					</div>
		</div>
	
=#

#=
<span class="fu_motto">Editions, done right, for learners.</span>
		<span class="cc_license"><a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">CC-BY-NC</a></span>
		<a href="https://github.com/Furman-University-Editions/OedipusTyrannos"><img alt="github" class="github_logo" height="30px" src="GitHub-Mark-Light-120px-plus.png"/></a>
=#

bottomSmallPrint = dcc_markdown("""*A Latin Dictionary.* Founded on Andrews’ edition of Freund's Latin dictionary, revised, enlarged, and in great part rewritten by Charlton T. Lewis, Ph.D., and Charles Short, LL.D. (Oxford: Clarendon Press, 1879). Text provided by Perseus Digital Library, with funding from The National Endowment for the Humanities. Original version available for viewing and download at <http://www.perseus.tufts.edu/>. This application is ©2022, Christopher W. Blackwell, licensed under the [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.en.html). CITE/CTS is ©2002–2022 Neel Smith and Christopher Blackwell. The implementations of this [CITE-based](http://cite-architecture.github.io/) app were written by Neel Smith and Christopher Blackwell using [Julia](https://julialang.org) and the [Dash.jl](https://github.com/plotly/dash.jl) framework. Licensed under the [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.en.html). The dictionary data is [is on Github](https://github.com/Eumaeus/cex_lewis_and_short). Sourcecode on GitHub. Report bugs by filing issues on GitHub.""")

