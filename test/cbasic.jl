using Clang
using Clang.LibClang
using Test

@testset "c basic" begin
    # parse file
    transUnit = parse_header(joinpath(@__DIR__, "c", "cbasic.h"),
                             flags = CXTranslationUnit_DetailedPreprocessingRecord |
                                     CXTranslationUnit_SkipFunctionBodies)
    GC.@preserve transUnit begin
        # get root cursor
        top = getcursor(transUnit)
        # search the first macro defination "#define CONST 1"
        cursorCONST = search(top, x->kind(x)==CXCursor_MacroDefinition && name(x) == "CONST")
        toksCONST = tokenize(cursorCONST[1])
        @test kind(toksCONST[1]) == CXToken_Identifier
        @test kind(toksCONST[2]) == CXToken_Literal
        @test toksCONST[2].text == "1"
        # search the second macro defination "#define CONSTADD CONST + 2"
        cursorCONSTADD = search(top, x->kind(x)==CXCursor_MacroDefinition && name(x) == "CONSTADD")
        toksCONSTADD = tokenize(cursorCONSTADD[1])
        @test toksCONSTADD[1].text == "CONSTADD"
        @test toksCONSTADD[2].text == "CONST"
        @test toksCONSTADD[3].text == "+"
        @test toksCONSTADD[4].text == "2"

        # function arguments
        func1 = search(top, "func1")[1]
        @test argnum(func1) == 4
        func1_args = function_args(func1) # TODO should return a structure or namedtuple
        @test map(spelling, func1_args) == ["a","b","c","d"]
        @test endswith(filename(func1), joinpath("c", "cbasic.h"))
    end
end
