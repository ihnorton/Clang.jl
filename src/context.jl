abstract type AbstractContext end

mutable struct DefaultContext <: AbstractContext
    index::Index
    trans_units::Vector{TranslationUnit}
    options::Dict{String,Bool}
    libname::String
    force_name::String
    common_buffer::OrderedDict{Symbol,ExprUnit}
    api_buffer::Vector
    next_cursor::Dict{CLCursor,Union{CLCursor,Nothing}}
    queue::Queue{CLCursor}
    visited::Set{CLCursor}
    anonymous_counter::Int
end
DefaultContext(index::Index) = DefaultContext(index, TranslationUnit[], Dict{String,Bool}(),
                                              "libxxx", "", OrderedDict{Symbol,ExprUnit}(), [],
                                              Dict{CLCursor,Union{CLCursor,Nothing}}(),
                                              Queue{CLCursor}(), Set{CLCursor}(), 0)
DefaultContext(diagnostic::Bool=true) = DefaultContext(Index(diagnostic))

parse_header!(ctx::AbstractContext, header::AbstractString; args...) = push!(ctx.trans_units, parse_header(header; args...))
parse_headers!(ctx::AbstractContext, headers::Vector{String}; args...) = (ctx.trans_units = parse_headers(headers; args...);)
