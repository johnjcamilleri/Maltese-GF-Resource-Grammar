abstract VParts = {

  cat
    Cl ;
    NP ;
    VP ;
    V ;

  fun
    open_V : V ;
    she_NP, we_NP : NP ;
    window_NP : NP ;

    UseV : V -> VP ;
    Compl : VP -> NP -> VP ;
    PredVP : NP -> VP -> Cl ;
    PredVPNeg : NP -> VP -> Cl ;

}
