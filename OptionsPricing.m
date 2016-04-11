BeginPackage["OptionsPricing`"]

call::usage := "call[strike, spot, time, vola] returns {theoretical value, delta, gamma, vega, theta}"

put::usage := "put[strike, spot, time, vola] returns {theoretical value, delta, gamma, vega, theta}"

Begin["`Private`"]

call[strike_, spot_, time_, vola_] :=
 Module[
  {
   d1 = (Log[spot/strike] + vola^2/2*time/365)/(vola*Sqrt[time/365]),
   d2 = (Log[spot/strike] - vola^2/2*time/365)/(vola*Sqrt[time/365]),
   cdf = .5 Erfc[-#/Sqrt[2]] &,
   dtcdf = Exp[-#^2/2]/Sqrt[2*Pi] &
   },
  {
   spot*cdf[d1] - strike*cdf[d2],
   cdf[d1],
   dtcdf[d1]/(spot*vola*Sqrt[time/365]),
   spot*dtcdf[d1]*Sqrt[time/365]/100,
   -spot*dtcdf[d1]*vola/(2*Sqrt[time/365])/365
   }
  ]
  
put[strike_, spot_, time_, vola_] :=
 Module[
  {
   d1 = (Log[spot/strike] + vola^2/2*time/365)/(vola*Sqrt[time/365]),
   d2 = (Log[spot/strike] - vola^2/2*time/365)/(vola*Sqrt[time/365]),
   cdf = .5 Erfc[-#/Sqrt[2]] &,
   dtcdf = Exp[-#^2/2]/Sqrt[2*Pi] &
   },
  {
   strike*cdf[-d2] - spot*cdf[-d1],
   cdf[d1] - 1,
   dtcdf[d1]/(spot*vola*Sqrt[time/365]),
   spot*dtcdf[d1]*Sqrt[time/365]/100,
   -spot*dtcdf[d1]*vola/(2*Sqrt[time/365])/365
   }
  ]

End[]

EndPackage[]
