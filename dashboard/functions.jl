
function indexToWordUrn(idx = lsj_keys)
    map(idx) do item
        (item[2], item[3])
    end
end

function makeOption( l::String, v::String )
    (label = l, value = v)
end 

function makeOption( l::String, u::Cite2Urn )
    (label = l, value = "$u")
end 

function makeOption( l::SubString{String}, u::Cite2Urn )
    (label = l, value = "$u")
end 


function lexIndexToOptions(idx)
    map(idx) do item
        makeOption(item[2], item[3])
    end
end

function entryFindsToOptions(vef)
    map(vef) do item 
        makeOption(item[1], item[2])
    end
end

function filterLexIndex(greekString::String , idx = lsj_keys)
    filter(idx) do item
        startswith(transcodeGreek(item[1]), greekString)
    end
end


function getUrn(s::String)
   try
        Cite2Urn(s)
    catch err
        Nothing
    end
  
end

# Returns the entry for a lexicon entry
function lookupUrnEntry(u::Cite2Urn, lex::RawDataCollection = lexicon)::String
    entryVec = filter( x -> x.urn == u, lexicon)
    if (length(entryVec) < 1) ""
    else entryVec[1].entry
    end
end

# Returns the key for a lexicon entry
function lookupUrnKey(u::Cite2Urn, lex::RawDataCollection = lexicon)::String
    entryVec = filter( x -> x.urn == u, lexicon)
    if (length(entryVec) < 1) ""
    else entryVec[1].key
    end
end

# For a URN, return the first letter of the lemma
function firstLetterForUrn(u::Cite2Urn, lexKeys = lsj_keys)::String
    lexEntries = begin
        filter(lexKeys) do k
            k[3] == u
        end
    end
    if (length(lexEntries) < 1 ) ""
    else 
        thisKey = string(lexEntries[1][1][1])
        tempFirst = transcodeGreek(thisKey)
        if (tempFirst == "ς") "σ"
        else tempFirst
        end
    end
end

function firstLetterForUrn(s::String, lexKeys = lsj_keys)::String
    u = Cite2Urn(s)
    firstLetterForUrn(u)
end


# Functions for searching and retrieving
#   All of these use the lex_index, for speed and responsiveness

function lemmaEquals(s::String, idx::Vector{Tuple{SubString{String}, SubString{String}, CitableObject.Cite2Urn, SubString{String}}} = lsj_keys)::Vector{Tuple{String, Cite2Urn}}

    foundItems = begin
        filter(idx) do item
            item[1] == s
        end
    end

    map(foundItems) do item
        (item[2], item[3])
    end
    
end

function lemmaBeginsWith(s, idx = lsj_keys)::Vector{Tuple{String, Cite2Urn}}

    foundItems = begin
        filter(idx) do item
            startswith(item[1], s)
        end
    end

    map(foundItems) do item
        (item[2], item[3])
    end
    
end

function lemmaContains(s, idx = lsj_keys)::Vector{Tuple{String, Cite2Urn}}

    foundItems = begin
        filter(idx) do item
            contains(item[1], s)
        end
    end

    map(foundItems) do item
        (item[2], item[3])
    end
    
end

function entryContains(s, idx = lsj_keys)::Vector{Tuple{String, Cite2Urn}}

    foundItems = begin
        filter(idx) do item
            contains(item[4], s)
        end
    end

    map(foundItems) do item
        (item[2], item[3])
    end
    
end

function fullTextSearch(s::String, lex = lexicon)
    filteredLex = filter(lex) do item
        lcEntry = lowercase(item.entry)
        contains(lcEntry, s)
    end

    map(filteredLex) do item
        (item.key, item.urn)
    end
end

function isInLex(u::Cite2Urn, lex = lexicon)
    filt = filter(lexicon) do item
        item.urn == u
    end
    length(filt) > 0
end

function isInLex(s::String, lex = lexicon)
    u = Cite2Urn(s)
    filt = filter(lexicon) do item
        item.urn == u
    end
    length(filt) > 0
end
