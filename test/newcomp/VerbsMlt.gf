--# -path=.:alltenses:prelude:abstract
concrete VerbsMlt of Verbs =
  open ResMlt, ParadigmsMlt in {

flags
  coding=utf8 ;

lincat
  V = Verb;

lin
  antagonizza_V = mkV "antagonizza" ;
  bexxex_V = mkV_II "bexxex" ;
  cempel_V = mkV "ċempel" ;
  fetah_V = mkV "fetaħ" ;
  ggieled_V = mkV_VI "ġġieled" ;
  ghamel_V = mkV "għamel" "agħmel" ;
  gharghax_V = mkV "għargħax" ;
  habbat_V = mkV_II "ħabbat" ;
  harbat_V = mkV "ħarbat" ;
  hareg_V = mkV "ħareġ" ;
  hares_V = mkV_III "ħares" ;
  hass_V = mkV "ħass" ;
  hdar_V = mkV_IX "ħdar" ;
  kanta_V = mkV "kanta" "kanta" ;
  kisser_V = mkV_II "kisser" ;
  kiteb_V = mkV "kiteb" ;
  laghab_V = mkV "lagħab" "ilgħab" ;
  ltaqa'_V = mkV_VIII "ltaqa'" ;
  mexa_V = mkV "mexa" ;
  mtedd_V = mkV_VIII "mtedd" ;
  mtela_V = mkV_VIII "mtela" ;
  nbeda_V = mkV_VII "beda" "nbeda" ;
  nehha_V = mkV_II "neħħa" ;
  nfirex_V = mkV_VII "firex" "nfirex" ;
  ngabar_V = mkV_VII "ġabar" "nġabar" ;
  nhasel_V = mkV_VII "ħasel" "nħasel" ;
  nqata'_V = mkV_VII "qata'" "nqata'" ;
  nstab_V = mkV_VII "sab" "nstab" ;
  ntefaq_V = mkV_VIII "ntefaq" ;
  ntemm_V = mkV_VII "temm" "ntemm" ;
  ntghagen_V = mkV_VII "għaġen" "ntgħaġen" ;
  ntizen_V = mkV_VII "wiżen" "ntiżen" ;
  ntlewa_V = mkV_VII "lewa" "ntlewa" ;
  ntrifes_V = mkV_VII "rifes" "ntrifes" ;
  nxtamm_V = mkV_VII "xamm" "nxtamm" ;
  nxtehet_V = mkV_VII "xeħet" "nxteħet" ;
  qajjem_V = mkV_II "qajjem" ;
  qara_V = mkV "qara" "aqra" ;
  qata'_V = mkV "qata'" ;
  qatta'_V = mkV_II "qatta'" ;
  qieghed_V = mkV_III "qiegħed" ;
  rqaq_V = mkV_IX "rqaq" ;
  sab_V = mkV "sab" (mkRoot "s-j-b") ;
  serva_V = mkV "serva" ;
  ssellef_V = mkV_V "ssellef" ;
  sserva_V = derivedV_II "sserva" "sservi" (mkRoot "s-r-v-j") ;
  ssuggerixxa_V = mkV "ssuġġerixxa" ;
  staghgeb_V = mkV_X "stagħġeb" "għ-ġ-b" ;
  stahba_V = mkV_X "staħba" "ħ-b-j" ;
  stharreg_V = mkV_X "stħarreġ" "ħ-r-ġ" ;
  stqarr_V = mkV_X "stqarr" "q-r-r" ;
  strieh_V = mkV_X "strieħ" "s-r-ħ" ;
  tbezza'_V = mkV_V "tbeżża'" ;
  tbierek_V = mkV_VI "tbierek" ;
  tfacca_V = mkV_V "tfaċċa" ;
  tfejjaq_V = mkV_V "tfejjaq" ;
  thabat_V = mkV_VI "tħabat" ;
  tharbat_V = mkV_II "tħarbat" ;
  tkanta_V = derivedV_II "tkanta" "tkanta" (mkRoot "k-n-t-j") ;
  tkaza_V = mkV_VI "tkaża" ;
  tnizzel_V = mkV_V "tniżżel" ;
  tqieghed_V = mkV_VI "tqiegħed" ;
  twal_V = mkV_IX "twal" ;
  twassal_V = mkV_V "twassal" ;
  twiegeb_V = mkV_VI "twieġeb" ;
  waqaf_V = mkV "waqaf" "ieqaf" ;
  waqqaf_V = mkV_II "waqqaf" ;
  wasal_V = mkV "wasal" ;
  wiegeb_V = mkV_III "wieġeb" ;
  xamm_V = mkV "xamm" ;
  xtaq_V = mkV_VIII "xtaq" ;
  zied_V = mkV "żied" ;
  zviluppa_V = mkV "żviluppa" ;
}
