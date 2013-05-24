concrete ParamConc of Param = open Prelude in {

  param P = P1|P2|P3|P4;

  lincat
    S = Str;
    A = P => P => {s:Str;b:Bool};

  lin
    Start a = (a!P1!P1).s;
    It = \\ _,_ => {s="hello";b=True};
}
