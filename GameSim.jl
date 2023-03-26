using DataFrames, CSV, StatsBase, LinearAlgebra, DataConvenience, Distributions, StatsPlots

Sch = CSV.read("Sch23.csv", DataFrame)

function GameSim(home::Float64, away::Float64, TeamH::String, TeamA::String)
    HomeTeam = rand(Poisson(home), 10000)
    AwayTeam = rand(Poisson(away), 10000)
    scores = DataFrame([HomeTeam AwayTeam], [:Home, :Away])

    HomeWto0 = subset(scores, :Home => ByRow(score -> score ∈ [1,2,3,4,5,6,7,8,9,10]))
    subset!(HomeWto0, :Away => ByRow(score -> score == 0))
    HomeWto0Prob = (Int64(length(HomeWto0.Home)) / 10000)
    HomeWto0Odds = (1 / HomeWto0Prob)
    println("Prob of $TeamH win 123 to 0 $HomeWto0Prob ")
    println("Odds of $TeamH win 123 to 0 $HomeWto0Odds ")    

    HomeWto1 = subset(scores, :Home => ByRow(score -> score ∈ [2,3,4,5,6,7,8,9,10]))
    subset!(HomeWto1, :Away => ByRow(score -> score == 1))
    HomeWto1Prob = (Int64(length(HomeWto1.Home)) / 10000)
    HomeWto10Odds = (1 / HomeWto1Prob)

    HomeWto2 = subset(scores, :Home => ByRow(score -> score ∈ [3,4,5,6,7,8,9,10]))
    subset!(HomeWto2, :Away => ByRow(score -> score == 2))
    HomeWto2Prob = (Int64(length(HomeWto2.Home)) / 10000)
    HomeWto2Odds = (1 / HomeWto2Prob)


    AwayWto0 = subset(scores, :Away => ByRow(score -> score ∈ [1,2,3,4,5,6,7,8,9,10]))
    subset!(AwayWto0, :Home => ByRow(score -> score == 0))
    AwayWto0Prob = (Int64(length(AwayWto0.Away)) / 10000)
    AwayWto0Odds = (1 / AwayWto0Prob)
    println("Prob of $TeamA win 123 to 0 $AwayWto0Prob ")
    println("Odds of $TeamA win 123 to 0 $AwayWto0Odds ") 

    AwayWto1 = subset(scores, :Away => ByRow(score -> score ∈ [2,3,4,5,6,7,8,9,10]))
    subset!(AwayWto1, :Home => ByRow(score -> score == 1))
    AwayWto1Prob = (Int64(length(AwayWto1.Away)) / 10000)
    AwayWto1Odds = (1 / AwayWto1Prob)

    AwayWto2 = subset(scores, :Away => ByRow(score -> score ∈[3,4,5,6,7,8,9,10]))
    subset!(AwayWto2, :Home => ByRow(score -> score == 2))
    AwayWto2Prob = (Int64(length(AwayWto2.Away)) / 10000)
    AwayWto2Odds = (1 / AwayWto2Prob)

    HomeWinProb = HomeWto0Prob + HomeWto1Prob + HomeWto2Prob
    AwayWinProb = AwayWto0Prob + AwayWto1Prob + AwayWto2Prob
    DrawProb = 1.00 - HomeWinProb - AwayWinProb
    println("$TeamH win prob = $HomeWinProb")
    println("$TeamA win prob = $AwayWinProb")
    println("Draw = ")
    HomeWinOdds = 1 / HomeWinProb
    AwayWinOdds = 1 / AwayWinProb
    DrawOdds = 1 / DrawProb
    println("$TeamH win odds = $HomeWinOdds" )
    println("$TeamA win odds = $AwayWinOdds")
    println("Draw odds = $DrawOdds")


    homeg = @df scores histogram([:Home], label=("$TeamH"), xlabel="Goals", ylabel="Frequency")
    awayg = @df scores histogram([:Away], label=("$TeamA"), xlabel="Goals", ylabel="Frequency", color=:orange)
    
    savefig("HistScore$TeamH.png")

    GoalDens = @df scores density([:Home], label="$TeamH", xlabel="Goals", ylabel="Frequency")
    @df scores density!([:Away], label="$TeamA")
    savefig("DensityScores$TeamH.png")

    data = [HomeWinOdds, 2.00, DrawOdds, 3.40, AwayWinOdds, 3.60]
    labels = ["HWin", "FDHWin", "Draw", "FDDraw", "AWin", "FDWwin"]
    OddsBar = bar(data, xticks=(1:length(data), labels), title="OddsVsFanduel", xlabel="Bet Type", ylabel="Odds (Decimal)", legend=false)
    savefig("Odds$TeamH.png")

    plot(homeg, awayg, GoalDens, OddsBar, layout=(2,2))
    savefig("CombinedPlot.png")
end


GameSim(1.67, 1.17, "SD", "CHI")
