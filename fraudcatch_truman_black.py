import json



def findfraud(NAME):
    with open(NAME + '.json', encoding="utf8") as f:
        x = json.load(f)
    TotalVotesLostTrump = 0
    TotalVotesLostBiden = 0
    TrumpToThird = 0
    TrumpToBiden = 0
    BidenToTrump = 0
    ThirdToTrump = 0
    ThirdToBiden = 0
    BidenToThird = 0
    TotalVotesLostThird = 0
    series = x["data"]["races"][0]["timeseries"]
    for i in range(len(series)):
            thirdPartyNow = series[i]["votes"] * (1 - series[i]["vote_shares"]["bidenj"] - series[i]["vote_shares"]["trumpd"])
            thirdPartyThen = series[i-1]["votes"] * (1 - series[i-1]["vote_shares"]["bidenj"] - series[i-1]["vote_shares"]["trumpd"])
            TrumpNow = series[i]["votes"] * series[i]["vote_shares"]["trumpd"]
            TrumpThen = series[i-1]["votes"] * series[i-1]["vote_shares"]["trumpd"]
            BidenNow = series[i]["votes"] * series[i]["vote_shares"]["bidenj"]
            BidenThen = series[i-1]["votes"] * series[i-1]["vote_shares"]["bidenj"]
            if i != 0 and TrumpNow < TrumpThen and (TrumpThen - TrumpNow) > (0.00049999 * series[i]["votes"]) + 50:
                if BidenNow > BidenThen or thirdPartyNow > thirdPartyThen:
                    if TrumpNow - TrumpThen <= BidenNow - BidenThen or TrumpNow - TrumpThen <= thirdPartyNow - thirdPartyThen:
                        print ("(TRUMP")
                        print ("Index : " + str(i) + " Past Index : " + str(i-1))
                        print (TrumpNow - TrumpThen)
                        TrumpLostNow = TrumpThen - TrumpNow
                        TrumpLostTotal = TrumpThen - TrumpNow
                        if BidenNow > BidenThen and TrumpNow - TrumpThen <= BidenNow - BidenThen:
                            if BidenNow - BidenThen > TrumpLostTotal:
                                TrumpToBiden += TrumpLostTotal
                                TrumpLostTotal = 0
                            else:
                                TrumpToBiden += BidenNow - BidenThen
                                TrumpLostTotal -= BidenNow - BidenThen
                        if thirdPartyNow > thirdPartyThen and TrumpNow - TrumpThen <= thirdPartyNow - thirdPartyThen:
                            if thirdPartyNow - thirdPartyThen > TrumpLostTotal:
                                TrumpToThird += TrumpLostTotal
                                TrumpLostTotal = 0
                            else:
                                TrumpToThird += thirdPartyNow - thirdPartyThen
                                TrumpLostTotal -= thirdPartyNow - thirdPartyThen
                        if TrumpLostNow < 0:
                            TrumpLostNow = 0
                        TotalVotesLostTrump += TrumpLostNow - TrumpLostTotal
                        print ("TRUMP)")
            if i != 0 and BidenNow < BidenThen and (BidenThen - BidenNow) > (0.00049999 * series[i]["votes"]) + 50:
                if TrumpNow > TrumpThen or thirdPartyNow > thirdPartyThen:
                    if BidenNow - BidenThen <= TrumpNow - TrumpThen or BidenNow - BidenThen <= thirdPartyNow - thirdPartyThen:
                        print ("(BIDEN")
                        print ("Index : " + str(i) + " Past Index : " + str(i-1))
                        print (BidenNow - BidenThen)
                        BidenLostNow = BidenThen - BidenNow
                        BidenLostTotal = BidenThen - BidenNow
                        if TrumpNow > TrumpThen and BidenNow - BidenThen <= TrumpNow - TrumpThen:
                            if TrumpNow - TrumpThen > BidenLostTotal:
                                BidenToTrump += BidenLostTotal
                                BidenLostTotal = 0
                            else:
                                BidenToTrump += TrumpNow - TrumpThen
                                BidenLostTotal -= TrumpNow - TrumpThen
                        if thirdPartyNow > thirdPartyThen and BidenNow - BidenThen <= thirdPartyNow - thirdPartyThen:
                            if thirdPartyNow - thirdPartyThen > BidenLostTotal:
                                BidenToThird += BidenLostTotal
                                BidenLostTotal = 0
                            else:
                                BidenToThird += thirdPartyNow - thirdPartyThen
                                BidenLostTotal -= thirdPartyNow - thirdPartyThen
                        if BidenLostNow < 0:
                            BidenLostNow = 0
                        TotalVotesLostBiden += BidenLostNow - BidenLostTotal
                        print ("BIDEN)")
            if i!= 0 and thirdPartyNow < thirdPartyThen and (thirdPartyThen - thirdPartyNow) > (0.00049999 * series[i]["votes"]) + 50:
                if thirdPartyNow < thirdPartyThen:
                    if thirdPartyNow - thirdPartyThen <= TrumpNow - TrumpThen or thirdPartyNow - thirdPartyThen <= BidenNow - BidenThen:
                        print("(3RD PARTY")
                        print("Index : " + str(i) + " Past Index : " + str(i-1))
                        print (thirdPartyNow - thirdPartyThen)
                        ThirdLostTotal = thirdPartyThen - thirdPartyNow
                        ThirdLostNow = thirdPartyThen - thirdPartyNow
                        if BidenNow > BidenThen and thirdPartyNow - thirdPartyThen <= BidenNow - BidenThen:
                            if BidenNow - BidenThen > ThirdLostTotal:
                                ThirdToBiden += ThirdLostTotal
                                ThirdLostTotal = 0
                            else:
                                ThirdToBiden += BidenNow - BidenThen
                                ThirdLostTotal -= BidenNow - BidenThen
                        if TrumpNow > TrumpThen and thirdPartyNow - thirdPartyThen <= TrumpNow - TrumpThen:
                            if TrumpNow - TrumpThen > ThirdLostTotal:
                                ThirdToTrump += ThirdLostTotal
                                ThirdLostTotal = 0
                            else:
                                ThirdToTrump += TrumpNow - TrumpThen
                                ThirdLostTotal -= TrumpNow - TrumpThen
                        if ThirdLostNow < 0:
                            ThirdLostNow = 0
                        TotalVotesLostThird += ThirdLostNow - ThirdLostTotal
                        print ("3RD PARTY)")
    print (str(str(TotalVotesLostTrump)  + " TRUMP LOST"))
    print (str(TrumpToBiden) + " Trump to Biden")
    print (str(TrumpToThird) + " Trump to Third")
    print (str(str(TotalVotesLostBiden)  + " BIDEN LOST"))
    print (str(BidenToTrump) + " Biden to Trump")
    print (str(BidenToThird) + " Biden to Third")
    print (str(str(TotalVotesLostThird)  + " 3RD PARTY LOST"))
    print (str(ThirdToBiden) + " Third to Biden")
    print (str(ThirdToTrump) + " Third to Trump")
    if BidenToTrump > TrumpToBiden:
        print (str(BidenToTrump - TrumpToBiden) + " TRUMP")
    elif TrumpToBiden > BidenToTrump:
        print (str(TrumpToBiden - BidenToTrump) + " BIDEN")

def lostvotes(NAME):
    with open(NAME + '.json', encoding="utf8") as f:
        x = json.load(f)
    TotalVotesLost = 0
    TotalVotesLostBiden = 0
    TotalVotesLostTrump = 0
    TotalVotesLostThird = 0
    series = x["data"]["races"][0]["timeseries"]
    for i in range(len(series)):
        thirdPartyNow =  1 - series[i]["vote_shares"]["bidenj"] - series[i]["vote_shares"]["trumpd"]
        thirdPartyThen = 1 - series[i-1]["vote_shares"]["bidenj"] - series[i-1]["vote_shares"]["trumpd"]
        if (series[i]["vote_shares"]["bidenj"] < (series[i-1]["vote_shares"]["bidenj"] - 0.001) or series[i]["vote_shares"]["bidenj"] > (series[i-1]["vote_shares"]["bidenj"] + 0.001)) and (series[i]["vote_shares"]["trumpd"] < (series[i-1]["vote_shares"]["trumpd"] - 0.001) or series[i]["vote_shares"]["trumpd"] > (series[i-1]["vote_shares"]["trumpd"] + 0.001)):
            if i != 0 and series[i]["votes"] < series[i-1]["votes"] and series[i]["votes"] * series[i]["vote_shares"]["bidenj"] < series[i-1]["votes"] * series[i-1]["vote_shares"]["bidenj"] and series[i]["votes"] * series[i]["vote_shares"]["trumpd"] < series[i-1]["votes"] * series[i-1]["vote_shares"]["trumpd"]:
                TotalVotesLost += series[i]["votes"] - series[i-1]["votes"]
                print ("Index : " + str(i) + " Past Index : " + str(i-1))
                print (series[i]["votes"] - series[i-1]["votes"])
                TotalVotesLostTrump += series[i]["votes"] * series[i]["vote_shares"]["trumpd"] - series[i-1]["votes"] * series[i-1]["vote_shares"]["trumpd"]
                TotalVotesLostBiden += series[i]["votes"] * series[i]["vote_shares"]["bidenj"] - series[i-1]["votes"] * series[i-1]["vote_shares"]["bidenj"]
                TotalVotesLostThird += series[i]["votes"] * thirdPartyNow - series[i-1]["votes"] * thirdPartyThen
    print (str(TotalVotesLostTrump) + " TRUMP")
    print (str(TotalVotesLostBiden) + " BIDEN")
    print (str(TotalVotesLostThird) + " THIRD")
    print (TotalVotesLost)
