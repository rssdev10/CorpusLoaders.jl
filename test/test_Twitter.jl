using CorpusLoaders
using Test
using Base.Iterators
using MultiResolutionIterators

@testset "basic use $category" for category in ["train_pos", "train_neg", "test_pos", "test_neg"]
    twitter_gen = load(Twitter(category))
    tweets = collect(take(twitter_gen, 10))

    @test typeof(tweets) == @NestedVector(String, 3)

    words = flatten_levels(tweets, (!lvls)(Twitter, :words))|>full_consolidate
    @test typeof(words) == Vector{String}

    sentences = flatten_levels(tweets, (lvls)(Twitter, :documents))|>full_consolidate
    @test length([sent for sent in sentences if length(sent) != 0]) == length(sentences)
    @test sum(length.(sentences)) == length(words)

    @test typeof(flatten_levels(docs, (!lvls)(Twitter, :documents))|>full_consolidate) == Vector{String}
    @test typeof(flatten_levels(docs, (!lvls)(Twitter, :sentences))|>full_consolidate) == Vector{String}

end
