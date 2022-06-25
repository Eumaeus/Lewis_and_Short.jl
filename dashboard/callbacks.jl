# Translates typed BetaCode into Unicode, putting it in #greekOutput
callback!(app, Output("greekOutput", "children"), Input("greekInput", "value")) do input_value
        "$(BetaReader.transcodeGreek(input_value))"
end

# Responds to a click on the alphabet-list (on the left), by loading words in #volumeList
callback!(
    app, 
    Output("volumeList", "options"), 
    Input("volumeList", "value"),
    Input("alphaList", "value"),
    State("volumeList", "value"),
    prevent_initial_call=true) do input_valuev, input_valuea, input_state

        ctx = callback_context()
        trigger_id = ctx.triggered[1].prop_id

        input_value = begin
            if (trigger_id == "volumeList.value") 
                if (input_state == nothing) throw(PreventUpdate())
                elseif (input_state == "") throw(PreventUpdate())
                else
                    firstLetterForUrn(input_state)
                end
            else 
                input_valuea     
            end
        end


        filteredLex = filterLexIndex(input_value, lsj_keys)


        newOptions = begin
            if (input_value == "") 
                vec([])
            else 
                lexIndexToOptions(filteredLex)
            end
        end

       finalOptions = begin
           if (trigger_id == "volumeList.value")
                if (input_value == "") newOptions
                elseif (input_value == nothing) newOptions
                else 
                    firstItem = findfirst(item -> item.value == input_state, newOptions)
                    if (firstItem == nothing) 
                        throw(PreventUpdate())
                    elseif (firstItem < 21) newOptions
                    else
                        myEnd = (firstItem - 20)
                        myRange = 1:myEnd
                        deleteat!(newOptions, myRange)
                    end
                end
            else 
                newOptions
            end 
       end

    end

#Checks contents of #passageInput for a valid Cite2Urn; if there is one, activate button #querySubmit
callback!(
    app, 
    Output("querySubmit", "disabled"), 
    Input("passageInput", "value"),
    prevent_initial_call=true) do input_value

    trialUrn = getUrn(input_value)

    if (trialUrn == nothing) true
    else false
    end
end

#Checks contents of #passageInput for a valid Cite2Urn; if there is one, add that URN to the @value of button #querySubmit
callback!(
    app, 
    Output("querySubmit", "value"), 
    Input("passageInput", "value"),
    prevent_initial_call=true) do input_value

    trialUrn = getUrn(input_value)

    newValue::String = begin
        if (trialUrn == nothing) ""
        else string(trialUrn)
        end
    end

    newValue
end



#If there is a valid URN in #passageInput, change the text of button #querySubmit
callback!(
    app, 
    Output("querySubmit", "children"), 
    Input("querySubmit", "disabled"),
    prevent_initial_call=true) do input_value

    if (input_value) # == "disabled; true"
        "Enter a valid URN"
    else
        "Look up entry for URN"
    end

end

#= 
    A Switcher callback.
    Activated from from #passageInput, from #englishInput/#searchButton, or from #resultsList
=#
callback!(
    app,
    Output("selectedUrnP", "children"),
    Input("querySubmit", "n_clicks"),
    Input("resultsList", "value"),
    Input("thisUrl", "href"),
    State("querySubmit", "value"),
    prevent_initial_call = true) do qValue, rValue, uValue, qState

    # querySubmit.n_clicks
    # volumeList.value

    uParam = begin
        if (length(split(uValue, "?urn=")) < 2)
            ""
        else
            split(uValue, "?urn=")[2]
        end 
    end 

    ctx = callback_context()
    #println("Length of ctx.triggered: $(length(ctx.triggered))")
    trigger_id = ctx.triggered[1].prop_id

    if (trigger_id == "querySubmit.n_clicks")
        return qState
    elseif (trigger_id == "resultsList.value")
        return rValue
    elseif (trigger_id == "thisUrl.href")
        uParam
    else
        return ""
    end

    #return string(ctx) * " *** " * trigger_id

end



# When #volumeList-value changes, select it in lexEntry
callback!(
    app,
    Output("lexEntry", "children"),
    Input("volumeList", "value"),
    prevent_initial_call = true
    ) do input_value

    if (input_value == nothing) ""
    elseif (input_value == "") ""
    else
        trialUrn = getUrn(input_value)
        if (trialUrn == nothing) throw(PreventUpdate())
        elseif (trialUrn == "") throw(PreventUpdate())
        else
            lexEntry::String = lookupUrnEntry(trialUrn)
            return dcc_markdown(lexEntry)
        end
    end
end

# When #volumeList-value changes, get an entry's .key and put it in #lexEntryLabel
callback!(
    app,
    Output("lexEntryLabel", "children"),
    Input("volumeList", "value"),
    prevent_initial_call = true
    ) do input_value

    if (input_value == nothing) ""
    elseif (input_value == "") ""
    else
        trialUrn = getUrn(input_value)

        if (trialUrn == nothing) throw(PreventUpdate())
        else
            lexKey::String = lookupUrnKey(trialUrn)
            return dcc_markdown(lexKey)
        end
    end
end

# When #volumeList-value changes, update #alphaList
callback!(
    app, 
    Output("alphaList", "value"), 
    Input("volumeList", "value"),
    prevent_initial_call=true) do input_value

    if (input_value == nothing) throw(PreventUpdate())
    elseif (input_value == "") throw(PreventUpdate())
    else
        trialUrn = getUrn(input_value)

        if (trialUrn == nothing) throw(PreventUpdate())
        elseif (trialUrn == "") throw(PreventUpdate())
        else
            firstLetter::String = firstLetterForUrn(trialUrn)
            if (firstLetter == "") throw(PreventUpdate())
            else 
                firstLetter
            end
        end
    end
end

# When #volumeList is updated, zero the value of #passageInput
callback!(
    app,
    Output("passageInput", "value"),
    Input("volumeList", "value"),
    prevent_initial_call = true
    ) do input_value

    ""
end

# When #selectedUrnP changes update #volumeList
callback!(
    app,
    Output("volumeList", "value"),
    Input("selectedUrnP", "children"),
    prevent_initial_call = true
) do input_value

    if (input_value == nothing) ""
    elseif (input_value == "") ""
    else
        trialUrn = getUrn(input_value)

        if (trialUrn == nothing) throw(PreventUpdate())
        else
            return string(trialUrn)
        end
    end
end

# When #volumeList-value changes, update #lexEntryLink
callback!(
    app,
    Output("lexEntryLink", "children"),
    Input("volumeList", "value"),
    prevent_initial_call = true
    ) do input_value

    if (input_value == nothing) throw(PreventUpdate())
    else
        trialUrn = getUrn(input_value)

        if (trialUrn == nothing) throw(PreventUpdate())
        else
            linkUrl = "?urn=$(string(trialUrn))"
            html_a( href=linkUrl, "Link")            
        end
    end

end

# When #volumeList-value changes, update #lexEntryUrn
callback!(
    app,
    Output("lexEntryUrn", "children"),
    Input("volumeList", "value"),
    prevent_initial_call = true
    ) do input_value

    if (input_value == nothing) throw(PreventUpdate())
    else
        trialUrn = getUrn(input_value)

        if (trialUrn == nothing) throw(PreventUpdate())
        else
            html_a(string(trialUrn))            
        end
    end

end

# When #lexEntryUrn is populated, change the .class of #copyUrn
callback!(
    app,
    Output("copyUrn", "className"),
    Input("lexEntryUrn", "children"),
    prevent_initial_call = true
    ) do entry_value

        if (entry_value == "") throw(PreventUpdate())
        else "app_visible"
        end
end

# When something is typed and transformed into #greekOutput, update #resultsList options
callback!(
    app,
    Output("resultsList", "options"),
    Input("greekInput", "value"),
    Input("searchButton", "n_clicks"),
    Input("querySubmit", "n_clicks"),
    State("englishInput", "value"),
    prevent_initial_call = true) do input_valueG, input_valueS, input_valueQ, stateE

    ctx = callback_context()
    trigger_id = ctx.triggered[1].prop_id

    if (trigger_id == "greekInput.value")

        input_value = input_valueG

        sl = length(input_value)

        if (sl == 0) return []
        elseif (sl < 3) 
            le = lemmaEquals(input_value)
            allFound = cat(le, dims=1)
            entryFindsToOptions(allFound) |> unique
        elseif (sl < 4)
            le = lemmaEquals(input_value)
            lbw = lemmaBeginsWith(input_value)
            lc = lemmaContains(input_value)
            ec = entryContains(input_value)
           #allFound = cat(le, lbw, lc, ec, dims=1) |> unique
            allFound = cat(le, lbw, lc, ec, dims=1)
            entryFindsToOptions(allFound) |> unique
        elseif( sl < 5 )
            le = lemmaEquals(input_value)
            lbw = lemmaBeginsWith(input_value)
            lc = lemmaContains(input_value)
            ec = entryContains(input_value)
            #allFound = cat(le, lbw, lc, ec, dims=1) |> unique
            allFound = cat(le, lbw, lc, ec, dims=1)
            entryFindsToOptions(allFound) |> unique
        else
            le = lemmaEquals(input_value)
            lbw = lemmaBeginsWith(input_value)
            lc = lemmaContains(input_value)
            ec = entryContains(input_value)
            #allFound = cat(le, lbw, lc, ec, dims=1) |> unique
            allFound = cat(le, lbw, lc, ec, dims=1)
            entryFindsToOptions(allFound) |> unique
        end
    elseif (trigger_id == "querySubmit.n_clicks")
        []
    elseif (trigger_id == "searchButton.n_clicks")

        input_value = stateE

        allFound = fullTextSearch(input_value)
        entryFindsToOptions(allFound)

    else throw(PreventUpdate())
    end
end 

# When there are more than three characters in #englishInpus, change the .disabled of #searchButton to 'false'
callback!(
    app,
    Output("searchButton", "disabled"),
    Input("englishInput", "value"),
    prevent_initial_call = true ) do input_value

    if (length(input_value) < 3) true
    else
        false
    end 

end

# On open, stash #thisUrl.href
callback!(
    app,
    Output("urlDisplay", "children"),
    Input("thisUrl","href")) do input_value

    input_value

end